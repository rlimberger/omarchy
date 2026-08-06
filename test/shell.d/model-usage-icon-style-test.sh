#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

run_node_test <<'JS'
const fs = require('fs')
const panelSource = fs.readFileSync(root + '/shell/plugins/model-usage/Panel.qml', 'utf8')
const manifest = JSON.parse(fs.readFileSync(root + '/shell/plugins/model-usage/manifest.json', 'utf8'))

// ---- the two styles
assert(/setting\("barIconStyle", "Robot"\)/.test(panelSource), 'model-usage falls back to the robot style without a stored setting')
assert(/visible: !root\.usageIconStyle/.test(panelSource), 'model-usage hides the robot button in usage style')
assert(/visible: root\.usageIconStyle/.test(panelSource), 'model-usage shows the chips in usage style')
assert(/component UsageChip/.test(panelSource) && /model: root\.providers/.test(panelSource), 'model-usage draws one chip per subscription')
assert(/barPercentText/.test(panelSource) && /bindingWindow\(p\)/.test(panelSource), 'model-usage chips show the tightest limit')

// ---- the right-click menu
assert(/Qt\.RightButton\) styleMenuOpen = true/.test(panelSource), 'model-usage right click opens the style menu')
assert(/onClicked: root\.setIconStyle\(option\.style\)/.test(panelSource), 'model-usage style rows apply the pick')
assert(/function menu\(\): string \{ root\.styleMenuOpen = true/.test(panelSource), 'model-usage exposes the menu over IPC')
assert(/root\.refreshNow\(\)/.test(panelSource), 'model-usage keeps a refresh action in the menu')

// ---- persistence
assert(/for \(var key in root\.settings\) if \(key !== "id"\) entry\[key\] = root\.settings\[key\]/.test(panelSource), 'model-usage carries the existing settings into the persisted entry')
assert(/entry\.barIconStyle = style[\s\S]*root\.settings = entry[\s\S]*updateEntryInline/.test(panelSource), 'model-usage applies the picked style locally and writes it to shell.json')

// ---- shipped defaults
const defaults = manifest.barWidget.defaults
assertEqual(defaults.barIconStyle, 'Robot', 'model-usage ships the robot style as the default')
const styleField = manifest.barWidget.schema.find(function(field) { return field.key === 'barIconStyle' })
assert(!!styleField, 'model-usage exposes the icon style in the settings schema')
assertEqual(styleField.type, 'enum', 'model-usage offers the icon style as a choice')
assertDeepEqual(styleField.options, ['Robot', 'Usage'], 'model-usage offers exactly the two styles')
assertEqual(styleField.defaultValue, defaults.barIconStyle, 'model-usage schema default matches the shipped default')
JS
