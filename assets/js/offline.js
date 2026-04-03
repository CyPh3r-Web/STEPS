/**
 * STEPS Offline Sync System
 * Provides IndexedDB storage and auto-sync when network is restored
 */

const DB_NAME = 'steps_offline_db';
const DB_VERSION = 1;
const STORES = {
    grades: 'grades',
    students: 'students',
    syncQueue: 'sync_queue'
};

let db = null;
let isOnline = navigator.onLine;

// Initialize IndexedDB
async function initOfflineDB() {
    return new Promise((resolve, reject) => {
        const request = indexedDB.open(DB_NAME, DB_VERSION);
        
        request.onerror = () => reject(request.error);
        request.onsuccess = () => {
            db = request.result;
            resolve(db);
        };
        
        request.onupgradeneeded = (event) => {
            const database = event.target.result;
            
            // Store for grades pending sync
            if (!database.objectStoreNames.contains(STORES.grades)) {
                const gradeStore = database.createObjectStore(STORES.grades, { keyPath: 'id', autoIncrement: true });
                gradeStore.createIndex('student_id', 'student_id', { unique: false });
                gradeStore.createIndex('subject_id', 'subject_id', { unique: false });
                gradeStore.createIndex('synced', 'synced', { unique: false });
            }
            
            // Store for sync queue (general operations)
            if (!database.objectStoreNames.contains(STORES.syncQueue)) {
                const queueStore = database.createObjectStore(STORES.syncQueue, { keyPath: 'id', autoIncrement: true });
                queueStore.createIndex('type', 'type', { unique: false });
                queueStore.createIndex('timestamp', 'timestamp', { unique: false });
            }
        };
    });
}

// Save grade locally when offline
async function saveGradeOffline(gradeData) {
    if (!db) await initOfflineDB();
    
    return new Promise((resolve, reject) => {
        const transaction = db.transaction([STORES.grades], 'readwrite');
        const store = transaction.objectStore(STORES.grades);
        
        const data = {
            ...gradeData,
            synced: false,
            timestamp: new Date().toISOString()
        };
        
        const request = store.add(data);
        request.onsuccess = () => resolve(request.result);
        request.onerror = () => reject(request.error);
    });
}

// Get all unsynced grades
async function getUnsyncedGrades() {
    if (!db) await initOfflineDB();
    
    return new Promise((resolve, reject) => {
        const transaction = db.transaction([STORES.grades], 'readonly');
        const store = transaction.objectStore(STORES.grades);
        const index = store.index('synced');
        const request = index.openCursor(false);
        const results = [];
        
        request.onsuccess = () => {
            const cursor = request.result;
            if (cursor) {
                results.push(cursor.value);
                cursor.continue();
            } else {
                resolve(results);
            }
        };
        request.onerror = () => reject(request.error);
    });
}

// Mark grades as synced
async function markGradesSynced(ids) {
    if (!db) await initOfflineDB();
    
    const transaction = db.transaction([STORES.grades], 'readwrite');
    const store = transaction.objectStore(STORES.grades);
    
    for (const id of ids) {
        const request = store.get(id);
        request.onsuccess = () => {
            const data = request.result;
            if (data) {
                data.synced = true;
                store.put(data);
            }
        };
    }
}

// Sync grades with server
async function syncGrades() {
    const unsynced = await getUnsyncedGrades();
    if (unsynced.length === 0) return { synced: 0, failed: 0 };
    
    let synced = 0;
    let failed = 0;
    const syncedIds = [];
    
    for (const grade of unsynced) {
        try {
            const response = await fetch(BASE_URL + 'api/sync_grade.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(grade)
            });
            
            if (response.ok) {
                syncedIds.push(grade.id);
                synced++;
            } else {
                failed++;
            }
        } catch (error) {
            failed++;
        }
    }
    
    if (syncedIds.length > 0) {
        await markGradesSynced(syncedIds);
    }
    
    return { synced, failed };
}

// Update online status indicator
function updateOnlineStatus() {
    const indicator = document.getElementById('online-indicator');
    const statusText = document.getElementById('online-status-text');
    
    if (indicator) {
        if (navigator.onLine) {
            indicator.classList.remove('offline');
            indicator.classList.add('online');
            if (statusText) statusText.textContent = 'Online';
        } else {
            indicator.classList.remove('online');
            indicator.classList.add('offline');
            if (statusText) statusText.textContent = 'Offline';
        }
    }
    
    // Show/hide sync button based on connection
    const syncBtn = document.getElementById('sync-button');
    if (syncBtn) {
        syncBtn.style.display = navigator.onLine ? 'flex' : 'none';
    }
}

// Handle coming back online
async function handleOnline() {
    updateOnlineStatus();
    
    // Auto-sync grades
    const result = await syncGrades();
    if (result.synced > 0) {
        showSyncNotification(`Synced ${result.synced} grade(s) with server`);
    }
}

// Handle going offline
function handleOffline() {
    updateOnlineStatus();
    showSyncNotification('You are offline. Changes will be saved locally and synced when connection is restored.', 'warning');
}

// Show sync notification
function showSyncNotification(message, type = 'success') {
    if (typeof Toast !== 'undefined') {
        Toast.fire({
            icon: type,
            title: message
        });
    } else {
        console.log(`[SYNC] ${message}`);
    }
}

// Initialize offline system
document.addEventListener('DOMContentLoaded', async () => {
    try {
        await initOfflineDB();
        
        // Listen for online/offline events
        window.addEventListener('online', handleOnline);
        window.addEventListener('offline', handleOffline);
        
        // Initial status check
        updateOnlineStatus();
        
        // Attempt auto-sync on load if online
        if (navigator.onLine) {
            const result = await syncGrades();
            if (result.synced > 0) {
                showSyncNotification(`Auto-synced ${result.synced} pending grade(s)`);
            }
        }
    } catch (error) {
        console.error('Failed to initialize offline DB:', error);
    }
});

// Export for global access
window.StepsOffline = {
    saveGradeOffline,
    getUnsyncedGrades,
    syncGrades,
    isOnline: () => navigator.onLine
};
