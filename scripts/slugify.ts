import { slugify } from 'https://deno.land/x/slugify/mod.ts';

for (const sourceFileName of Deno.args) {
	console.log(slugify(sourceFileName).replace(/_+/g, '-').toLowerCase());
}

