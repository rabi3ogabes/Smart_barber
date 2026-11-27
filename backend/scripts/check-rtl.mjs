// Fails when layout code uses physical directions instead of logical ones (rule 7, design-system.md).
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';

const banned = /(?<![\w-])(?:-?m[lr]-|p[lr]-|left-|right-|rounded-[lr]-|rounded-[tb][lr]-|border-[lr]-|border-[lr](?=["'\s])|text-left|text-right|float-left|float-right|space-x-reverse|inset-[lr]-|scroll-m[lr]-|scroll-p[lr]-)/;
const files = [];
const walk = (dir) => {
    for (const name of readdirSync(dir)) {
        const path = join(dir, name);
        if (statSync(path).isDirectory()) walk(path);
        else if (/\.(vue|ts)$/.test(name)) files.push(path);
    }
};
walk('resources/js');

let failures = 0;
for (const file of files) {
    readFileSync(file, 'utf8').split('\n').forEach((line, i) => {
        if (line.includes('rtl-allow')) return;
        const match = line.match(banned);
        if (match) {
            failures++;
            console.error(`${file}:${i + 1}  physical direction "${match[0]}" — use ms-/me-/ps-/pe-/start-/end-/text-start/text-end`);
        }
    });
}

if (failures > 0) {
    console.error(`\n${failures} RTL violation(s).`);
    process.exit(1);
}
console.log(`RTL check passed (${files.length} files).`);
