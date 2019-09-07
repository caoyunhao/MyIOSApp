#coding=utf-8

headers = ["key", "en", "zh-Hans"]

info_plist_rows = [
    ["CFBundleDisplayName", "My Helper", "我的助手"],
]

rows = [
    ["CANCEL", "Cancel", "取消"],
    ["OK", "OK", "好的"],
    ["I_GOT_IT", "I got it", "我知道了"],
    ["CLOSE", "Close", "关闭"],
    ["DONE", "Done", "完成"],
    ["SUCCESS", "Success", "成功"],
    ["FAIL", "Fail", "失败"],
    ["NOTICE", "Notice", "提示"],
    ["JUMP", "Jump", "跳转"],
    ["SCAN", "Scan", "扫描"],
    ["ABLUM", "Ablum", "相册"],
    ["ADD", "Add", "添加"],
    ["CLEAR", "Clear", "清空"],
    
    ["TODO_LIST", "Todo List", "待办清单"],
    ["NEW_TASK", "New Task", "新任务"],
    ["KIND", "Kind", "类型"],
    ["PROJECT", "Project", "项目"],
    ["TITLE", "Title", "标题"],
    ["IMPORTENT", "Importent", "重要"],
    ["EMERGENCY", "Emergency", "紧急"],
    ["REMIND", "Remind", "提醒"],
    ["DETAIL", "Detail", "详情"],
        
    ["PASTEBOARD_HISTORY", "Pasteboard History", "粘贴板历史"],
    ["CLEAR_CURRENT", "Clear Current", "清空当前"],
    
    ["UTILITIES", "Utilities", "工具"],
    ["CONTACT", "Contact", "联系人"],
    ["ADD_PHONETIC", "Add Phonetic", "添加排序字段"],
    
    ["IMAGE", "Image", "图片"],
    ["MODIFY", "Modify", "修改"],
    ["LIVE_PHONE_TOOL", "Live Photo Tool", "实况照片工具"],
        
        
    ["VIDEO", "Video", "视频"],
    ["TO_GIF", "To GIF", "转为 GIF"],
    
    ["LOCAL_STORAGE", "Local Storage", "本地存储"],

    ["ABOUT", "About", "关于"],
    ["DEVICE_INFO", "Device Information", "设备信息"],
    ["DEVELOPER_WEBSITE", "Developer Website", "作者网站"],
]

# generate Localizable.strings file

for language_index, language in enumerate(headers): 
    if language_index == 0: continue
    with open("./{}.lproj/Localizable.strings".format(language), "w") as f:
        for row_index, row in enumerate(rows):
            key = row[0]
            cur_row_data = row[language_index]
            f.write("\"{}\" = \"{}\";\n".format(key, cur_row_data))

for language_index, language in enumerate(headers):
    if language_index == 0: continue
    with open("./InfoPlist/{}.lproj/InfoPlist.strings".format(language), "w") as f:
        for row_index, row in enumerate(info_plist_rows):
            key = row[0]
            cur_row_data = row[language_index]
            f.write("\"{}\" = \"{}\";\n".format(key, cur_row_data))

# generate LocalizedStrings.swift file

localized_strings_text = """
// Generated File.

import Foundation

class LocalizedStrings {
"""
for row in rows:
    key = row[0]
    localized_strings_text += """
    static var %s: String {
        return LocalizationHelper.shared.value(forKey: "%s")
    }
""" % (key, key)
localized_strings_text += "}"


with open("./LocalizedStrings.swift", "w") as f:
    f.write(localized_strings_text)
