import checkbox from '@inquirer/checkbox'

export default async function optionSelect(selections: string[]) {
  const selection = await checkbox({
    message: 'Select options',
    choices: selections.map((s) => ({ name: s, value: s })),
  });
  return selection;
}


