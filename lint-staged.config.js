module.exports = {
    '**/*.+(json|mdx|md|js|jsx|ts|tsx|css|yml|yaml|xml)': (filesArray) => {
        const files = filesArray.join(' ');
        return [`pnpm exec prettier --write ${files}`];
    },
    '**/*.dart': (files) => {
        const nonGenerated = files.filter((file) => !file.includes('.g.'));

        return [
            `dart format ${files.join(' ')}`,
            `dart analyze ${nonGenerated.join(' ')} --fatal-infos --fatal-warnings`,
        ];
    },
    'libs/bricks/templates/**/*': () => {
        return ['sip run bricks generate'];
    },
    'pubspec.yaml': () => {
        return [
            'sip run sync-version',
            'git add packages/cli/lib/src/version.dart',
        ];
    },
};
