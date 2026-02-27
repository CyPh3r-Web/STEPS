// STEPS - Main JavaScript

// ============================================
// THEME SYSTEM
// ============================================
function initTheme() {
    const saved = localStorage.getItem('steps_theme') || 'blue';
    applyTheme(saved);
}

function applyTheme(themeName) {
    document.documentElement.setAttribute('data-theme', themeName);
    document.querySelectorAll('.theme-swatch').forEach(s => {
        s.classList.toggle('active', s.getAttribute('data-theme') === themeName);
    });
}

function setTheme(themeName) {
    applyTheme(themeName);
    localStorage.setItem('steps_theme', themeName);
    closeThemeDropdown();
    Toast.fire({ icon: 'success', title: 'Theme updated' });
}

function toggleThemeDropdown() {
    const dd = document.getElementById('themeDropdown');
    if (dd) dd.classList.toggle('active');
}

function closeThemeDropdown() {
    const dd = document.getElementById('themeDropdown');
    if (dd) dd.classList.remove('active');
}

document.addEventListener('click', function(e) {
    const picker = e.target.closest('.theme-picker');
    if (!picker) closeThemeDropdown();
});

document.addEventListener('DOMContentLoaded', initTheme);

// ============================================
// SWEETALERT2
// ============================================
const Toast = Swal.mixin({
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true,
    customClass: {
        popup: 'swal-poppins'
    },
    didOpen: (toast) => {
        toast.onmouseenter = Swal.stopTimer;
        toast.onmouseleave = Swal.resumeTimer;
    }
});

const swalDefaults = {
    customClass: {
        popup: 'swal-poppins',
        title: 'swal-title',
        htmlContainer: 'swal-text',
        confirmButton: 'swal-btn-confirm',
        cancelButton: 'swal-btn-cancel'
    },
    buttonsStyling: false
};

function showAlert(message, type = 'success') {
    const config = {
        success: { icon: 'success', title: 'Success' },
        error:   { icon: 'error',   title: 'Error' },
        warning: { icon: 'warning', title: 'Warning' },
        info:    { icon: 'info',    title: 'Information' }
    };

    Toast.fire({
        icon: config[type]?.icon || 'info',
        title: message
    });
}

function showAlertFull(message, type = 'success', title = '') {
    const config = {
        success: { icon: 'success', defaultTitle: 'Success' },
        error:   { icon: 'error',   defaultTitle: 'Something went wrong' },
        warning: { icon: 'warning', defaultTitle: 'Warning' },
        info:    { icon: 'info',    defaultTitle: 'Information' }
    };

    Swal.fire({
        ...swalDefaults,
        icon: config[type]?.icon || 'info',
        title: title || config[type]?.defaultTitle || 'Notice',
        text: message,
        confirmButtonColor: '#2563eb'
    });
}

function confirmAction(message, callback, title = 'Are you sure?') {
    Swal.fire({
        ...swalDefaults,
        title: title,
        text: message,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, proceed',
        cancelButtonText: 'Cancel',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            callback();
        }
    });
}

function confirmDelete(formElement, itemName = 'this item') {
    Swal.fire({
        ...swalDefaults,
        title: 'Remove ' + itemName + '?',
        text: 'This action cannot be undone.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, remove',
        cancelButtonText: 'Cancel',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            formElement.submit();
        }
    });
}

function confirmDanger(formElement, title, text) {
    Swal.fire({
        ...swalDefaults,
        title: title,
        text: text,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, continue',
        cancelButtonText: 'Cancel',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            formElement.submit();
        }
    });
}

function confirmSubmit(formElement, title, text, confirmText = 'Confirm') {
    Swal.fire({
        ...swalDefaults,
        title: title,
        text: text,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: confirmText,
        cancelButtonText: 'Cancel',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            formElement.submit();
        }
    });
}

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebar-overlay');
    sidebar.classList.toggle('-translate-x-full');
    overlay.classList.toggle('hidden');
}

function toggleSidebarCollapse() {
    const sidebar = document.getElementById('sidebar');
    const btn = sidebar.querySelector('.sidebar-collapse-btn');
    const collapsed = sidebar.classList.toggle('sidebar-collapsed');
    document.body.classList.toggle('sidebar-collapsed', collapsed);
    localStorage.setItem('steps_sidebar_collapsed', collapsed ? '1' : '0');
    if (btn) btn.title = collapsed ? 'Expand sidebar' : 'Collapse sidebar';
}

function initSidebarCollapse() {
    const sidebar = document.getElementById('sidebar');
    if (!sidebar) return;
    const saved = localStorage.getItem('steps_sidebar_collapsed');
    const isLg = window.matchMedia('(min-width: 1024px)').matches;
    if (saved === '1' && isLg) {
        sidebar.classList.add('sidebar-collapsed');
        document.body.classList.add('sidebar-collapsed');
        const btn = sidebar.querySelector('.sidebar-collapse-btn');
        if (btn) btn.title = 'Expand sidebar';
    }
}

document.addEventListener('DOMContentLoaded', initSidebarCollapse);

function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (!modal) return;
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';

    const firstInput = modal.querySelector('input:not([type="hidden"]), select, textarea');
    if (firstInput) {
        setTimeout(() => firstInput.focus(), 350);
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (!modal) return;
    const content = modal.querySelector('.modal-content');
    if (content) {
        content.style.transform = 'translateY(12px) scale(0.97)';
        content.style.opacity = '0';
    }
    setTimeout(() => {
        modal.classList.remove('active');
        document.body.style.overflow = '';
        if (content) {
            content.style.transform = '';
            content.style.opacity = '';
        }
    }, 200);
}

function exportTableToCSV(tableId, filename) {
    const table = document.getElementById(tableId);
    if (!table) return;

    let csv = [];
    const rows = table.querySelectorAll('tr');

    rows.forEach(row => {
        const cols = row.querySelectorAll('td, th');
        const rowData = [];
        cols.forEach(col => {
            let text = col.innerText.replace(/"/g, '""');
            rowData.push('"' + text + '"');
        });
        csv.push(rowData.join(','));
    });

    const blob = new Blob([csv.join('\n')], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename || 'export.csv';
    link.click();
    URL.revokeObjectURL(link.href);

    Toast.fire({ icon: 'success', title: 'File exported successfully' });
}

function filterTable(inputId, tableId) {
    const filter = document.getElementById(inputId).value.toLowerCase();
    const table = document.getElementById(tableId);
    const rows = table.querySelectorAll('tbody tr');

    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
    });
}

// Auto-inject search bar for all .steps-table
function initTableSearch() {
    document.querySelectorAll('.steps-table').forEach(function(table) {
        const container = table.closest('.rounded-xl');
        if (!container || container.querySelector('.table-search-bar')) return;

        const searchBar = document.createElement('div');
        searchBar.className = 'table-search-bar';
        searchBar.innerHTML = '<input type="text" class="table-search-input form-input" placeholder="Search table..." autocomplete="off" />';

        const insertBefore = table.closest('.overflow-x-auto') || table;
        insertBefore.parentNode.insertBefore(searchBar, insertBefore);

        const input = searchBar.querySelector('input');
        input.addEventListener('input', function() {
            const term = this.value.toLowerCase().trim();
            table.querySelectorAll('tbody tr').forEach(function(tr) {
                tr.style.display = tr.textContent.toLowerCase().includes(term) ? '' : 'none';
            });
        });
    });
}
document.addEventListener('DOMContentLoaded', initTableSearch);

document.addEventListener('click', function(e) {
    if (e.target.classList.contains('modal-overlay') && e.target.classList.contains('active')) {
        closeModal(e.target.id);
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => {
            closeModal(modal.id);
        });
    }
});
