// Every t('key') used in resources/js must exist in both lang/ar.json and lang/en.json, and the two files must have the same keys.
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';

const ar = JSON.parse(readFileSync('lang/ar.json', 'utf8'));
const en = JSON.parse(readFileSync('lang/en.json', 'utf8'));
const problems = [];

for (const key of Object.keys(en)) if (!(key in ar)) problems.push(`missing in ar.json: ${key}`);
for (const key of Object.keys(ar)) if (!(key in en)) problems.push(`missing in en.json: ${key}`);

const walk = (dir, out = []) => {
    for (const name of readdirSync(dir)) {
        const path = join(dir, name);
        if (statSync(path).isDirectory()) walk(path, out);
        else if (/\.(vue|ts)$/.test(name)) out.push(path);
    }
    return out;
};

const used = /\bt\(\s*'([a-z0-9_.]+)'/g;
for (const file of walk('resources/js')) {
    const source = readFileSync(file, 'utf8');
    for (const [, key] of source.matchAll(used)) {
        if (!(key in en)) problems.push(`${file}: unknown key ${key}`);
    }
}

if (problems.length) {
    console.error(problems.join('\n'));
    process.exit(1);
}
console.log(`i18n check passed (${Object.keys(en).length} keys).`);
