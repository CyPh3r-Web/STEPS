    </main>

    <footer class="px-6 py-4 border-t border-gray-200 bg-white">
        <p class="text-xs text-gray-400 text-center">&copy; <?= date('Y') ?> <?= SITE_FULL_NAME ?>. All rights reserved.</p>
    </footer>
</div>

<script src="<?= BASE_URL ?>assets/js/main.js"></script>
<?php if (isset($extraScripts)): ?>
    <?php foreach ($extraScripts as $script): ?>
        <script src="<?= $script ?>"></script>
    <?php endforeach; ?>
<?php endif; ?>
</body>
</html>
