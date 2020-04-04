const {project} = require('@raydeck/xcode');
const {writeFileSync} = require('fs');
const {join} = require('path');
const {sync: glob} = require('glob');

//Get non-pod path
const addSwiftDebugFlag = (referencePath = process.cwd()) => {
  const paths = glob(
    join(referencePath, 'ios', '**', 'project.pbxproj'),
  ).filter((path) => !path.includes('/Pods/'));
  const path = paths.pop();
  console.log(path);
  const p = new project(path);
  p.parseSync();
  Object.entries(p.hash.project.objects.XCBuildConfiguration)

    .filter(([, value]) => typeof value !== 'string')
    .filter(([, value]) => value.name === 'Debug')
    // .forEach(([key, value]) => console.log('another guy', key, value));
    .forEach(([key, value]) => {
      console.log(
        ' found with key',
        key,
        value.buildSettings.OTHER_SWIFT_FLAGS,
      );
      if (
        value.buildSettings &&
        value.buildSettings.OTHER_SWIFT_FLAGS &&
        !value.buildSettings.OTHER_SWIFT_FLAGS.includes('-D DEBUG')
      ) {
        const end = (value.buildSettings.OTHER_SWIFT_FLAGS = value.buildSettings.OTHER_SWIFT_FLAGS.substring(
          value.buildSettings.OTHER_SWIFT_FLAGS.length - 1,
          1,
        ));
        value.buildSettings.OTHER_SWIFT_FLAGS =
          value.buildSettings.OTHER_SWIFT_FLAGS.substring(
            0,
            value.buildSettings.OTHER_SWIFT_FLAGS.length - 1,
          ) +
          ' -D DEBUG' +
          end;
        console.log('Made the change');
      } else {
        value.buildSettings.OTHER_SWIFT_FLAGS = '"$(inherited) -D DEBUG"';
      }
    });
  const out = p.writeSync();
  writeFileSync(path, out);
};
module.exports = addSwiftDebugFlag;
