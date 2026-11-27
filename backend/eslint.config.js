import js from '@eslint/js';
import pluginVue from 'eslint-plugin-vue';
import tseslint from 'typescript-eslint';
import vueParser from 'vue-eslint-parser';

export default [
    { ignores: ['public/**', 'vendor/**', 'node_modules/**', 'bootstrap/ssr/**', 'storage/**'] },
    js.configs.recommended,
    ...tseslint.configs.recommended,
    ...pluginVue.configs['flat/recommended'],
    {
        files: ['resources/js/**/*.{ts,vue}'],
        languageOptions: {
            parser: vueParser,
            parserOptions: { parser: tseslint.parser, extraFileExtensions: ['.vue'], sourceType: 'module' },
            globals: { window: 'readonly', document: 'readonly', localStorage: 'readonly', navigator: 'readonly' },
        },
        rules: {
            // TypeScript already checks undefined names (incl. DOM types); the core rule misfires on them.
            'no-undef': 'off',
            'vue/multi-word-component-names': 'off',
            'vue/max-attributes-per-line': 'off',
            'vue/singleline-html-element-content-newline': 'off',
            'vue/html-indent': ['error', 4],
            'vue/html-self-closing': ['error', { html: { void: 'always', normal: 'never', component: 'always' } }],
            // Rule 7: no raw strings in templates; use t('…'). Allowed: symbols, the logo mark and each language's own name.
            'vue/no-bare-strings-in-template': ['error', { allowlist: ['·', '—', '/', '×', '+', '-', '%', ':', '⌘', 'K', 'Ctrl', '(', ')', '*', '•', '…', '⌘K', 'S', 'العربية', 'English'] }],
        },
    },
];
