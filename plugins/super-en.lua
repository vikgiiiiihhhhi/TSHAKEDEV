--[[ 
    _____    _        _    _    _____    Dev @lIMyIl 
   |_   _|__| |__    / \  | | _| ____|   Dev @li_XxX_il
     | |/ __| '_ \  / _ \ | |/ /  _|     Dev @h_k_a
     | |\__ \ | | |/ ___ \|   <| |___    Dev @Aram_omar22
     |_||___/_| |_/_/   \_\_|\_\_____|   Dev @IXX_I_XXI
              CH > @lTSHAKEl_CH
من سورس ديف بوينت :)
--]]
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "للادمـــــنـــــيـــه🗣فـــــقـــــط⚠️")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = 'no',
		  lock_link = "no",
          flood = 'yes',
		  lock_spam = 'yes',
		  lock_sticker = 'no',
		  member = 'no',
		  public = 'no',
		  lock_rtl = 'no',
		  lock_tgservice = 'yes',
		  lock_contacts = 'no',
		  strict = 'no'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
   local text = 'تــم ✔️ تفعيــل هــذه الــمــجــمــوعــة 👥\n'..msg.to.title
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local text = 'تــم ❌ تعطيــل هــذه الــمــجــمــوعــة 👥\n'..msg.to.title
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="معلومات عن الــمــجــمــوعــة👥 :\n"..result.title.."\n\n"
local admin_num = "عــدد الادمــنيــهـ👥 :\n"..result.admins_count.."\n"
local user_num = "عــدد الاعــضــاء👥 :\n"..result.participants_count.."\n"
local kicked_num = "الاعــضــاء الاكــثــر تــفــاعــلا👥 :\n"..result.kicked_count.."\n"
local channel_id = "ايــديـ🆔 الــمــجــمــوعــة👥 :\n"..result.peer_id.."\n"
if result.username then
	channel_username = "مــعــرف الــمــجــمــوعــة👥 :\n@"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "اعــضــاء🗣 الــمــجــمــوعــة👥\n"..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username Channel : @DevPointTeam
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "🗣 قــائــمــه ايــديــات الاعــضــاء 👥"..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end

--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    return 'الروابط بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الروابط في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    return 'الروابط بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الروابط في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
    end
end

local function lock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'yes' then
    return 'all settings is already locked 🔐\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['all'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'all settings has been locked 🔐\n👮 Order by :️ @'..msg.from.username
  end
end


local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'no' then
    return 'all settings is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['all'] = 'no'
    save_data(_config.moderation.data, data)
    return 'all settings has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username

  end
end

local function lock_group_etehad(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_etehad_lock = data[tostring(target)]['settings']['etehad']
  if group_etehad_lock == 'yes' then
    return 'etehad setting is already locked'
  else
    data[tostring(target)]['settings']['etehad'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'etehad setting has been locked'
  end
end

local function unlock_group_etehad(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_etehad_lock = data[tostring(target)]['settings']['etehad']
  if group_etehad_lock == 'no' then
    return 'etehad setting is not locked'
  else
    data[tostring(target)]['settings']['etehad'] = 'no'
    save_data(_config.moderation.data, data)
    return 'etehad setting has been unlocked'
  end
end

local function lock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_leave_lock = data[tostring(target)]['settings']['leave']
  if group_leave_lock == 'yes' then
    return 'leave is already locked 🔐\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['leave'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'leave has been locked 🔐\n👮 Order by :️ @'..msg.from.username
  end
end

local function unlock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_leave_lock = data[tostring(target)]['settings']['leave']
  if group_leave_lock == 'no' then
    return 'leave is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['leave'] = 'no'
    save_data(_config.moderation.data, data)
    return 'leave has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username
  end
end

local function lock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == 'yes' then
    return 'operator is already locked 🔐\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['operator'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'operator has been locked 🔐\n👮 Order by :️ @'..msg.from.username
  end
end

local function unlock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == 'no' then
    return 'operator is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['operator'] = 'no'
    save_data(_config.moderation.data, data)
    return 'operator has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username
  end
end

local function lock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == 'yes' then
    return 'Reply is already locked 🔐\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['reply'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'Reply has been locked 🔐\n👮 Order by :️ @'..msg.from.username
  end
end

local function unlock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == 'no' then
    return 'Reply is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['reply'] = 'no'
    save_data(_config.moderation.data, data)
    return 'Reply has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username
  end
end

local function lock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'yes' then
    return 'المعرفات بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['username'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 المعرفات في مجموعتك 👥\nبواسطه 🔸--🔹 @'..msg.from.username or 'لا يوجد'..'\n'
  end
end

local function unlock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'no' then
    return 'المعرفات بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
    else
data[tostring(target)]['settings']['username'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 المعرفات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == 'yes' then
    return 'Media is already locked 🔐\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['media'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'Media has been locked 🔐\n👮 Order by :️ @'..msg.from.username
  end
end

local function unlock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == 'no' then
    return 'Media is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['media'] = 'no'
    save_data(_config.moderation.data, data)
    return 'Media has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username
  end
end

local function lock_group_fosh(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fosh_lock = data[tostring(target)]['settings']['fosh']
  if group_fosh_lock == 'yes' then
    return 'badword is already locked 🔐\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['fosh'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'badword has been locked 🔐\n👮 Order by :️ @'..msg.from.username
  end
end

local function unlock_group_fosh(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fosh_lock = data[tostring(target)]['settings']['fosh']
  if group_fosh_lock == 'no' then
    return 'badword is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['fosh'] = 'no'
    save_data(_config.moderation.data, data)
    return 'badword has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username
  end
end

local function lock_group_join(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_join_lock = data[tostring(target)]['settings']['join']
  if group_join_lock == 'yes' then
    return 'الدخول بالرابط بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_join'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الدخول بالرابط في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_join(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_join_lock = data[tostring(target)]['settings']['lock_join']
  if group_join_lock == 'no' then
    return 'الدخول بالرابط بالتاكيد تم ⚠️ فتحه 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_join'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الدخول بالرابط في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == 'yes' then
    return 'التوجيه بالتاكيد تم ☑️ قفله 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['fwd'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 التوجيه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == 'no' then
    return 'التوجيه بالتاكيد تم ⚠️ فتحه 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['fwd'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 التوجيه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == 'yes' then
    return 'English is already locked 🔐\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['english'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'English has been locked 🔐\n👮 Order by :️ @'..msg.from.username
  end
end

local function unlock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == 'no' then
    return 'English is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['english'] = 'no'
    save_data(_config.moderation.data, data)
    return 'English has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username
  end
end

local function lock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == 'yes' then
    return 'السمايلات بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['emoji'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 السمايلات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == 'no' then
    return 'السمايلات بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['emoji'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 السمايلات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == 'yes' then
    return 'التاك بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['tag'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 التاك في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == 'no' then
    return 'التاك بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['tag'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 التاك في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'no' then
    return 'all settings is not locked 🔓\n👮 Order by :️ @'..msg.from.username
  else
    data[tostring(target)]['settings']['all'] = 'no'
    save_data(_config.moderation.data, data)
    return 'all settings has been unlocked 🔓\n👮 Order by :️ @'..msg.from.username
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_momod(msg) then
    return "للادمـــــنـــــيـــه🗣فـــــقـــــط⚠️"
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
    return 'الكلايش بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الكلايش في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
    return 'الكلايش بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الكلايش في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    return 'التكرار بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 التكرار في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return 'التكرار بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 التكرار في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    return 'اللغه العربيه بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 اللغه العربيه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end
local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    return 'اللغه العربيه بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 اللغه العربيه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end


local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    return 'الاضافه بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
    return 'تم ☑️ قفل 🔐 الاضافه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    return 'الاضافه بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الاضافه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
    return 'الاضافه الجماعيه بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الاضافه الجماعيه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
    return 'الاضافه الجماعيه بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الاضافه الجماعيه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'yes' then
    return 'الاشعارات بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الاشعارات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'no' then
    return 'الاشعارات بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الاشعارات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
    return 'الملصقات بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الملصقات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end
local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'no' then
    return 'الملصقات بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الملصقات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'yes' then
    return 'البوتات بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 البوتات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'no' then
    return 'البوتات بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 البوتات في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'yes' then
    return 'جهات الاتصال بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 جهات الاتصال في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'no' then
    return 'جهات الاتصال بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 جهات الاتصال في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'yes' then
    return 'الطرد بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['strict'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الطرد في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'no' then
    return 'الطرد بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['strict'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الطرد في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['cmd']
  if group_cmd_lock == 'yes' then
    return 'الشارحه بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['cmd'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الشارحه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['cmd']
  if group_cmd_lock == 'no' then
    return 'الشارحه بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['cmd'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الشارحه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_unsupported(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_unsupported_lock = data[tostring(target)]['settings']['unsupported']
  if group_unsupported_lock == 'yes' then
    return 'الانلاين بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['unsupported'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 الانلاين في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_unsupported(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_unsupported_lock = data[tostring(target)]['settings']['unsupported']
  if group_unsupported_lock == 'no' then
    return 'الانلاين بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['unsupported'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 الانلاين في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function lock_group_ads(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_ads_lock = data[tostring(target)]['settings']['lock_ads']
  if group_ads_lock == 'yes' then
    return 'جميع الروابط بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_ads'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تم ☑️ قفل 🔐 جميع الروابط في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end

local function unlock_group_ads(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_ads_lock = data[tostring(target)]['settings']['lock_ads']
  if group_ads_lock == 'no' then
    return 'جميع الروابط بالتاكيد تم ⚠️ فتحه 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  else
    data[tostring(target)]['settings']['lock_ads'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تم ⚠️ فتح 🔓 جميع الروابط في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
  end
end
--End supergroup locks

--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'تـــمـ☑️ وضـــع الـقـوانــ📝ــيـن للــمــجــمــوعــة 👥'
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'لـ⚠️ـمـ يــتـمـ وضــع الـقـوانــ📝ــيـن للــمــجــمــوعــة 👥'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..'\nقـوانــ📝ــيـن الـمـمـجـموعــهـ👥\nهــي👇\n'..rules:gsub("/n", " ")
  return rules
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return "للادمـــــنـــــيـــه🗣فـــــقـــــط⚠️"
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'yes' then
    return 'الـمـجـمـوعـه 👥 بـالـتـاكـيـد ☑️ عـامـه الان\nبواسطه 🔸--🔹 @'..msg.from.username..'\n'
  else
    data[tostring(target)]['settings']['public'] = 'yes'
    save_data(_config.moderation.data, data)
  end
    return 'الـمـجـمـوعـه 👥 اصـبـحـت ☑️ عـامـه الان\nبواسطه 🔸--🔹 @'..msg.from.username..'\n'
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
 data[tostring(target)]['long_id'] = msg.to.peer_id
 save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'no' then
    return 'الـمـجـمـوعـه 👥 بـالـتـاكـيـد ☑️ لـيـسـت عـامـه الان\nبواسطه 🔸--🔹 @'..msg.from.username..'\n'
  else
    data[tostring(target)]['settings']['public'] = 'no'
    data[tostring(target)]['long_id'] = msg.to.long_id 
    save_data(_config.moderation.data, data)
    return 'الـمـجـمـوعـه 👥 اصـبـحـت ☑️ لـيـسـت عـامـه الان\nبواسطه 🔸--🔹 @'..msg.from.username..'\n'
  end
end

--Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 5
      	end
    end
    local bots_protection = "Yes"
    if data[tostring(target)]['settings']['lock_bots'] then
    	bots_protection = data[tostring(target)]['settings']['lock_bots']
   	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
        end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['tag'] then
			data[tostring(target)]['settings']['tag'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['emoji'] then
			data[tostring(target)]['settings']['emoji'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['english'] then
			data[tostring(target)]['settings']['english'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['fwd'] then
			data[tostring(target)]['settings']['fwd'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['reply'] then
			data[tostring(target)]['settings']['reply'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['join'] then
			data[tostring(target)]['settings']['join'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['fosh'] then
			data[tostring(target)]['settings']['fosh'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['username'] then
			data[tostring(target)]['settings']['username'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['media'] then
			data[tostring(target)]['settings']['media'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['leave'] then
			data[tostring(target)]['settings']['leave'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['all'] then
			data[tostring(target)]['settings']['all'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['operator'] then
			data[tostring(target)]['settings']['operator'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['etehad'] then
			data[tostring(target)]['settings']['etehad'] = 'no'
		end
	end
  local gp_type = data[tostring(msg.to.id)]['group_type']
  
  local settings = data[tostring(target)]['settings']
  local text = "🔺----------------------🔺\nاعدادات المجموعه :-\n💠- اسم المجموعه : "..msg.to.title.."\n🔺----------------------🔺\n💠- الروابط : "..settings.lock_link.."\n💠- جهات الاتصال : "..settings.lock_contacts.."\n💠- التكرار  : "..settings.flood.."\n💠- عدد التكرار : "..NUM_MSG_MAX.."\n💠- الاسبام : "..settings.lock_spam.."\n💠- العربيه : "..settings.lock_arabic.."\n💠- الانكليزيه : "..settings.english.."\n💠- الاضافه : "..settings.lock_member.."\n  \n💠- الرتل : "..settings.lock_rtl.."\n💠- اشعارات الدخول : "..settings.lock_tgservice.."\n💠- الملصقات : "..settings.lock_sticker.."\n💠- التاك : "..settings.tag.."\n💠- الاسمايلات : "..settings.emoji.."\n💠- البوتات : "..bots_protection.."\n💠- اعاده توجيه : "..settings.fwd.."\n💠- الدخول : "..settings.join.."\n💠- المعرف : "..settings.username.."\n🔺----------------------🔺\n @lTSHAKEl_CH"
  return text
end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' هــو بالــفــعــل ☑️ ـضــمــن الادمــنيــه👥')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' هــو بالــفــعــل ☑️ ـضــمــن الادمــنيــه👥')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return send_large_msg(receiver, 'الــمــجــمــوعــة👥لـــيـــســـتــ⚠️فـــعـــالـــه🚶')
  end
  if data[group]['moderators'][tostring(user_id)] then
return send_large_msg(receiver, member_username..' — الــعــضـــو\nبـالـتـاكـيـد تـمـ☑️رفـعـه ادمـن👥' ) 
end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' -- عــزيــزي\n تـمـ☑️ رفـعـك ضـــمـــن الادمــنيــه👥')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'الــمــجــمــوعــة👥لـــيـــســـتــ⚠️فـــعـــالـــه🚶')
  end
  if not data[group]['moderators'][tostring(user_id)] then
return send_large_msg(receiver, member_username..' -- الــعــضـــو \nبالتــاكيــد تــمــ⚠️ـتنــزيــله من الادمـنـيـه👥' )
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username.. ' -- عــزيــزي\n تــمــ⚠️ـتنــزيلــك مـــن الادمـنـيـه👥')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return 'الــمــجــمــوعــة👥لـــيـــســـتــ⚠️فـــعـــالـــه🚶'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return 'لــ⚠️ــا يــوجــد ادمـــنـــيـــه👥'
  end
  local i = 1
  local message = '\nقـــائـــمـــه الادمـــنيــهـ👥 ️ ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for: ["..result.from.peer_id.."]")
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id by service msg for: ["..user_id.."]")
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for msg fwd from: ["..result.fwd_from.peer_id.."]")
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
               return send_large_msg("channel#id"..channel_id, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــطــــرد الادمـــن👥")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــطــــرد الاداري👥")
    end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
               return send_large_msg("channel#id"..channel_id, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــطــــرد الادمـــن👥")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــطــــرد الاداري👥")
    end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply to sev. msg.")
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted a message by reply")
	elseif get_cmd == "add admin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
            text = "عــزيــزي [@"..result.from.username.."] \nتـمـ☑️ رفـعـك ضـــمـــن الاداريــن👥"
		else
            text = "عــزيــزي [ "..user_id.." ] \nتـمـ☑️ رفـعـك ضـــمـــن الاداريــن👥"
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..user_id.."] as admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "del admin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
            return send_large_msg(channel_id, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــطــــرد الاداري👥")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
            text = "عــزيــزي [@"..result.from.username.. "] \nتـمـ⚠️ ازالـتـــكـ مـــن الاداريــن👥"
        else
            text = "عــزيــزي [ "..user_id.." ] \nتـمـ⚠️ ازالـتـــكـ مـــن الاداريــن👥"
        end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted: ["..user_id.."] from admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "add owner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..result.from.peer_id.."] as owner by reply")
			if result.from.username then
				text = "@"..result.from.username.." [ "..result.from.peer_id.." ] \nتـمـ☑️ رفـعـك مــد😸يــر للــمــجــمــوعــة👥"
			else
				text = "[ "..result.from.peer_id.." ] \nتـمـ☑️ رفـعـك مــد😸يــر للــمــجــمــوعــة👥"
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "add mod" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "del mod" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
send_large_msg(receiver, " ["..user_id.."] \nتـمـ⚠️ ا��ـغـاء كـتـمـك 🔕 فـي الــمــجــمــوعــة👥 ")
        elseif is_momod(msg) then
            mute_user(chat_id, user_id)
            send_large_msg(receiver, " ["..user_id.."] \nتـمـ☑️ كـتـمـك 🔕 فـي الــمــجــمــوعــة👥")
        end
	end
end
-- End by reply actions

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "del admin" then
		if is_admin2(result.peer_id) then
            return send_large_msg(receiver, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــتنــزيــل الاداري👥")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
            text = "عــزيــزي [@"..result.username.."] \nتـمـ⚠️ ازالـتـــكـ مـــن الاداريــن👥"
            send_large_msg(receiver, text)
        else
            text = "عــزيــزي [ "..result.peer_id.." ] \nتـمـ⚠️ ازالـتـــكـ مـــن الاداريــن👥"
            send_large_msg(receiver, text)
        end
	elseif get_cmd == "add mod" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "del mod" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	--[[elseif get_cmd == "channel_block" then
		local user_id = result.peer_id
		local channel_id = extra.channelid
    local sender = extra.sender
    if member_id == sender then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
		if is_momod2(member_id, channel_id) and not is_admin2(sender) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		channel_set_admin(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been set as an admin"
			send_large_msg(channel_id, text)
		end
		elseif Dev = Point
	elseif get_cmd == "setowner" then
		local receiver = extra.channel
		local channel = string.gsub(receiver, 'channel#id', '')
		local from_id = extra.from_id
		local group_owner = data[tostring(channel)]['set_owner']
		if group_owner then
			local user = "user#id"..group_owner
			if not is_admin2(group_owner) and not is_support(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
			savelog(channel, name_log.." ["..from_id.."] set ["..result.peer_id.."] as owner by username")
		if result.username then
			text = member_username.." [ "..result.peer_id.." ] added as owner"
		else
			text = "[ "..result.peer_id.." ] added as owner"
		end
		send_large_msg(receiver, text)
  end]]
	elseif get_cmd == "add mod" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "del mod" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "del admin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
            return send_large_msg(channel_id, " لــ⚠️ــا تـسـتـطـيعــ🔕ــتنــزيــل الاداري👥")
  end
        channel_demote(channel_id, user_id, ok_cb, false)
        if result.username then
            text = "عــزيــزي [@"..result.username.."] \nتـمـ⚠️ ازالـتـــكـ مـــن الاداريــن👥"
            send_large_msg(channel_id, text)
        else
            text = "عــزيــزي [ "..result.peer_id.." ] \nتـمـ⚠️ ازالـتـــكـ مـــن الاداريــن👥"
            send_large_msg(channel_id, text)
        end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
            send_large_msg(receiver, " ["..user_id.."] \nتـمـ⚠️ الـغـاء كـتـمـك 🔕 فـي الــمــجــمــوعــة👥")
        elseif is_momod(extra.msg) then
            mute_user(chat_id, user_id)
            send_large_msg(receiver, " ["..user_id.."] \nتـمـ☑️ كـتـمـك 🔕 فـي الــمــجــمــوعــة👥")
        end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = 'لايوجد عضو @'..member..' في هذه المجموعه.'
  else
    text = 'لايوجد عضو  ['..memberid..'] في هذه المجموعه.'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــطــــرد الادمـــن👥")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, " لــ⚠️ــا تـسـتـطـيـعــ🔕ــطــــرد الاداري👥")
      end
      if v.username then
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..v.username.." ["..v.peer_id.."]")
      else
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..v.peer_id.."]")
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "add admin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "عــزيــزي [@"..v.username.."] ["..v.peer_id.."] \nتـمـ☑️ رفـعـك ضـــمـــن الاداريــن👥"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..v.username.." ["..v.peer_id.."]")
      else
        text = "عــزيــزي ["..v.peer_id.."] \nتـمـ☑️ رفـعـك ضـــمـــن الاداريــن👥"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin "..v.peer_id)
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
 elseif get_cmd == 'add owner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
					savelog(channel, name_log.."["..from_id.."] set ["..v.peer_id.."] as owner by username")
				if result.username then
      	text = member_username.." ["..v.peer_id.."] \nتـمـ☑️ رفـعـك مــد😸يــر للــمــجــمــوعــة👥"
				else
					text =" ["..v.peer_id.."] \nتـمـ☑️ رفـعـك مــد😸يــر للــمــجــمــوعــة👥"
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				savelog(channel, name_log.."["..from_id.."] set ["..memberid.."] as owner by username")
				text = "["..memberid.."] \nتـمـ☑️ رفـعـك مــد😸يــر للــمــجــمــوعــة👥"
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions

--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'تـمـ☑️ حـفـظـ الـصـ📷ـورهـ الــمــجــمــوعــة👥', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

--Run function
local function DevPointTeam(msg, matches)
	if msg.to.type == 'chat' then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
            return "الــمــجــمــوعــة👥 خـارقـهـ🚀 بـالـفعـل😸"
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
			if matches[1] == 'add' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
		  local iDev1 = "الــمــجــمــوعــة👥 بـالـفعـلـ😸 تـمـ☑️ تـفـعـيـلـهـا❗️"
		   return send_large_msg(receiver, iDev1)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") added")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] added SuperGroup")
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end
		if matches[1] == 'rem' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				return reply_msg(msg.id, 'الــمــجــمــوعــة👥 بـالـفعـلـ😸 تـمـ☑️ تـعـطـيـلـهـا❗️', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end--@DevPointTeam = Dont Remove
		if matches[1] == "gp info" then
			if not is_owner(msg) then
				return
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup info")
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1] == "admins" then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
            member_type = 'قـائـمـه👥 الاداريـن📝'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Admins list")
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "owner" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
                return "لـ⚠️ـا يـوجـد مــد😸يــر للــمــجــمــوعــة 👥"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
            return "مــد😸يــر الــمــجــمــوعــة 👥\n["..group_owner..']'
		end

		if matches[1] == "mods" then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group modlist")
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1] == "bots" and is_momod(msg) then
            member_type = 'تـمـ☑️ الـكـشـفـ عــن الـبوتـاتـ ‼️ فــي الــمــجــمــوعــة👥'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup bots list")
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup users list")
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1] == "kicked" and is_momod(msg) then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested Kicked users list")
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1] == 'cl' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'cl',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1] == 'bb' or matches[1] == 'kick' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'bb' or matches[1] == 'kick' and string.match(matches[2], '^%d+$') then
				--[[local user_id = matches[2]
				local channel_id = msg.to.id Dev = Point
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "You can't kick mods/owner/admins")
				end
				@DevPointTeam
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: [ user#id"..user_id.." ]")
				kick_user(user_id, channel_id)]]
				local	get_cmd = 'channel_block'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif msg.text:match("@[%a%d]") then
			--[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id Dev = Point
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'id' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested ID for: @"..username)
				resolve_username(username,  callbackres, cbres_extra)
			else
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup ID")
                return "ايـديـ🆔 الــمــجــمــوعــة👥"..string.gsub(msg.to.print_name, "_", " ")..": "..msg.to.id
			end
		end

		if matches[1] == 'kickme' then
			if msg.to.type == 'channel' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] left via kickme")
				channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
			end
		end

		if matches[1] == 'new lk' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
                    send_large_msg(receiver, 'لا يمكنك تغيير الرابط \nالمجموعه ليست من صنع البوت')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
                    send_large_msg(receiver, "تـمـ☑️ حـفـظـ رابـطـ الــمــجــمــوعــة👥")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] attempted to create a new SuperGroup link")
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1] == 'set lk' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
            return 'ارسـل رابـطـ الــمــجــمــوعــة👥'
		end

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
                return "تـمـ☑️ حـفـظـ رابـطـ الــمــجــمــوعــة👥"
			end
		end

		if matches[1] == 'lk' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
                return "يرجى ارسال [/set lk] لانشاء  رابط المجموعه"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
            return "رابـطـ الــمــجــمــوعــة👥 \n"..group_link
		end

		if matches[1] == "invite" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] invited @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1] == 'res' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] resolved username: @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		--[[if matches[1] == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
			@DevPointTeam
		end]]

			if matches[1] == 'add admin' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'add admin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'add admin' and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin' Dev   =   Point
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local	get_cmd = 'add admin'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'add admin' and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
				local	get_cmd = 'add admin'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'del admin' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del admin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'del admin' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'del admin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'del admin' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'del admin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted admin @"..username)
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'add owner' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'add owner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'add owner' and string.match(matches[2], '^%d+$') then
		--[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
					local text = "[ "..matches[2].." ] added as owner"
					return text Dev    =   Point
				end]]
				local	get_cmd = 'add owner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'add owner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'add owner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'add mod' then
		  if not is_momod(msg) then
				return
			end
            if not is_owner(msg) then 
                return "لـــلـــمــ🗣ــديـــر فـــقـــط⚠️" 
            end 
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'add mod',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'add mod' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'add mod'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'add mod' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'add mod',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'mp' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "ok"
		end
		if matches[1] == 'md' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "ok"
		end

		if matches[1] == 'del mod' then
			if not is_momod(msg) then
				return
			end
            if not is_owner(msg) then 
                return "لـــلـــمــ🗣ــديـــر فـــقـــط⚠️" 
            end 
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del mod',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'del mod' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'del mod'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'del mod'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == "set na" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..matches[2])
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..msg.to.title)
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1] == "set ab" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup description to: "..about_text)
			channel_set_about(receiver, about_text, ok_cb, false)
            return "تـمـ☑️ تـعـيـنـ📝ـوصـف الــمــجــمــوعــة👥\n\n"
		end

		if matches[1] == "set us" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
                    send_large_msg(receiver, "تـمـ☑️ وضـع مـعـرف الــمــجــمــوعــة👥\n\n")
                elseif success == 0 then
                    send_large_msg(receiver, "فـشـلـ⚠️ تـعـيـنـ❗️مـعـرف الــمــجــمــوعــة👥")
                end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1] == 'set ru' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group rules to ["..matches[2].."]")
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set new SuperGroup photo")
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1] == 'set ph' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] started setting new SuperGroup photo")
            return 'ارســلـ😸 صــورهـ📷 الـ❗️ـان'
		end

		if matches[1] == 'cl' then
			if not is_momod(msg) then
				return
			end
            if not is_owner(msg) then 
                return "لـــلـــمــ🗣ــديـــر فـــقـــط⚠️" 
            end 
			if matches[2] == 'mods' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
                    return 'عـذرا لـ⚠️ـا يـوجـد ادمـنـ🗣ـيـه لـيـتــم مـسـ❌ـحـهـم'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
                return 'تـمـ☑️ مــســح قــا📝ئــمــه الادمـنـيـه🗣'
			end
			if matches[2] == 'ru' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
                    return "عـذرا لـ⚠️ـا يـوجـد قـوانــ📝ــيـن لـيـتــم مـسـ❌ـحـهـا"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
                return 'تـــمـ☑️ مـسـح الـقـوانــ📝ــيـن للــمــجــمــوعــة 👥'
			end
			if matches[2] == 'ab' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
                    return "عـذرا لـ⚠️ـا يـوجـد وصــ📝ــف لـيـتــم مـسـ❌ـحـه"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
				channel_set_about(receiver, about_text, ok_cb, false)
                return 'تـــمـ☑️ مـسـح وصــ📝ــف الــمــجــمــوعــة 👥'
			end
			if matches[2] == 'sils' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
                return 'تـــمـ☑️ مـسـح قـائـ📝ـمـه الـمـكتـومـيـن👥'
			end
			if matches[2] == 'us' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
                        send_large_msg(receiver, "تـــمـ☑️ مـسـح معــ❗️ــرف الــمــجــمــوعــة 👥")
                    elseif success == 0 then
                        send_large_msg(receiver, "عــ⚠️ــذرا فــشــلــ❗️مــســح مـعــرف الــمــجــمــوعــة👥")
                    end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
		end

		if matches[1] == 'c' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'all' then
      	local safemode ={
        lock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		lock_group_arabic(msg, data, target),
		lock_group_membermod(msg, data, target),
		lock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		lock_group_sticker(msg, data, target),
		lock_group_contacts(msg, data, target),
		lock_group_english(msg, data, target),
		lock_group_fwd(msg, data, target),
		lock_group_reply(msg, data, target),
		lock_group_join(msg, data, target),
		lock_group_emoji(msg, data, target),
		lock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		lock_group_media(msg, data, target),
		lock_group_leave(msg, data, target),
		lock_group_bots(msg, data, target),
		lock_group_operator(msg, data, target),
      	}
      	return lock_group_all(msg, data, target), safemode
      end
			     if matches[2] == 'etehad' then
      	local etehad ={
        unlock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		lock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		lock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		lock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		lock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		lock_group_leave(msg, data, target),
		lock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return lock_group_etehad(msg, data, target), etehad
      end
			if matches[2] == 'lk' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked link posting ")
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'jo' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked join ")
				return lock_group_join(msg, data, target)
			end
			if matches[2] == 'tg' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked tag ")
				return lock_group_tag(msg, data, target)
			end			
			if matches[2] == 'sp' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked spam ")
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'fl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked flood ")
				return lock_group_flood(msg, data, target)
			end
			if matches[2] == 'ar' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked arabic ")
				return lock_group_arabic(msg, data, target)
			end
			if matches[2] == 'mb' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked member ")
				return lock_group_membermod(msg, data, target)
			end		    
			if matches[2]:lower() == 'rt' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end
			if matches[2] == 'ts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked Tgservice Actions")
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'st' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'ct' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked contact posting")
				return lock_group_contacts(msg, data, target)
			end
			if matches[2] == 'kc' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
			if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked english")
				return lock_group_english(msg, data, target)
			end
			if matches[2] == 'fd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fwd")
				return lock_group_fwd(msg, data, target)
			end
			if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked reply")
				return lock_group_reply(msg, data, target)
			end
			if matches[2] == 'ej' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked emoji")
				return lock_group_emoji(msg, data, target)
			end
			if matches[2] == 'badword' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked fosh")
				return lock_group_fosh(msg, data, target)
			end
			if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked media")
				return lock_group_media(msg, data, target)
			end
			if matches[2] == 'us' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked username")
				return lock_group_username(msg, data, target)
			end
			if matches[2] == 'leave' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked leave")
				return lock_group_leave(msg, data, target)
			end
			if matches[2] == 'bt' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots")
				return lock_group_bots(msg, data, target)
			end
			if matches[2] == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked operator")
				return lock_group_operator(msg, data, target)
			end
	  	if matches[2] == 'cm' then
			 	savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked cmd")
			  return lock_group_cmd(msg, data, target)
	    end
     	if matches[2] == 'in' then
			  savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked unsupported")
				return lock_group_unsupported(msg, data, target)
    end
	  	if matches[2] == 'alk' then
		    savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked ads ")
		    return lock_group_ads(msg, data, target)
			      end
		end

		if matches[1] == 'o' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'all' then
      	local dsafemode ={
        unlock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		unlock_group_spam(msg, data, target),
		unlock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		unlock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		unlock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return unlock_group_all(msg, data, target), dsafemode
      end
	  	if matches[2] == 'etehad' then
      	local detehad ={
        lock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_english(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_reply(msg, data, target),
		unlock_group_join(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_username(msg, data, target),
		unlock_group_fosh(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_leave(msg, data, target),
		unlock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return unlock_group_etehad(msg, data, target), detehad
      end
			if matches[2] == 'lk' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked link posting")
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'jo' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked join")
				return unlock_group_join(msg, data, target)
			end
			if matches[2] == 'tg' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tag")
				return unlock_group_tag(msg, data, target)
			end			
			if matches[2] == 'sp' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'fl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked flood")
				return unlock_group_flood(msg, data, target)
			end
			if matches[2] == 'ar' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked Arabic")
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'mb' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked member ")
				return unlock_group_membermod(msg, data, target)
			end                   
			if matches[2]:lower() == 'rt' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked RTL chars. in names")
				return unlock_group_rtl(msg, data, target)
			end
				if matches[2] == 'ts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked tgservice actions")
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'st' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'ct' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked contact posting")
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'kc' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
			if matches[2] == 'english' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked english")
				return unlock_group_english(msg, data, target)
			end
			if matches[2] == 'fd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fwd")
				return unlock_group_fwd(msg, data, target)
			end
			if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked reply")
				return unlock_group_reply(msg, data, target)
			end
			if matches[2] == 'ej' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled emoji")
				return unlock_group_emoji(msg, data, target)
			end
			if matches[2] == 'badword' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked fosh")
				return unlock_group_fosh(msg, data, target)
			end
			if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked media")
				return unlock_group_media(msg, data, target)
			end
			if matches[2] == 'us' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked disabled username")
				return unlock_group_username(msg, data, target)
			end
			if matches[2] == 'leave' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked leave")
				return unlock_group_leave(msg, data, target)
			end
			if matches[2] == 'bt' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots")
				return unlock_group_bots(msg, data, target)
			end
			if matches[2] == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked operator")
				return unlock_group_operator(msg, data, target)
			end
		  if matches[2] == 'cm' then
	     	savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked cmd")
				return unlock_group_cmd(msg, data, target)
	  	end
    	if matches[2] == 'in' then
	    	savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked unsupported")
	   		return unlock_group_unsupported(msg, data, target)
    	end
	   	if matches[2] == 'alk' then
	      savelog(msg.to.id, name_log.." ["..msg.from.id.."] unlocked ads")
	      return unlock_group_ads(msg, data, target)
			      end
		end

		if matches[1] == 'set fl' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 5 or tonumber(matches[2]) > 30 then
                return "ضـ☑️ـع تــكــرار😸مــن 5 الى 30 🗣"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
            return 'تـــمـ☑️ تـعـيـيـن📝الــتــكــرار لــلــعــد🗣\n👇\n'..matches[2]
		end
		if matches[1] == 'public' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == 'no' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: not public")
				return unset_public_membermod(msg, data, target)
			end
		end

		if matches[1] == 'c' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'au' then
			local msg_type = 'Audio'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
    return 'تم ☑️ قفل 🔐 الصوت 🎤 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الصوتيات 🎤 بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
			end
			if matches[2] == 'ph' then
			local msg_type = 'Photo'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
    return 'تم ☑️ قفل 🔐 الصور 🗼 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الصور 🗼 بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
			end
			if matches[2] == 'vi' then
			local msg_type = 'Video'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
    return 'تم ☑️ قفل 🔐 الفيديو 🎥 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الفيديوهات 🎥 بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
			end
			if matches[2] == 'gi' then
			local msg_type = 'Gifs'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
    return 'تم ☑️ قفل 🔐 المتحركه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'المتحركه بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'dc' then
			local msg_type = 'Documents'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
    return 'تم ☑️ قفل 🔐 الفايلات 📚 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الفايلات 📚 بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'tx' then
			local msg_type = 'Text'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
    return 'تم ☑️ قفل 🔐 الدردشه 📝 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الدردشه 📝 بالتاكيد تم ☑️ قفلها 🔐 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'gp' then
			local msg_type = 'All'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
    return 'تم ☑️ قفل 🔐 المجموعه 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'المجموعه 👥 بالتاكيد تم ☑️ قفلها 🔐\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
        end
		if matches[1] == 'o' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'au' then
			local msg_type = 'Audio'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
    return 'تم ⚠️ فتح 🔓 الصوتيات 🎤 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الصوتيات 🎤 با��تاكيد تم �����️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'ph' then
			local msg_type = 'Photo'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
    return 'تم ⚠️ فتح 🔓 الصور 🗼 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الصور 🗼 بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'vi' then
			local msg_type = 'Video'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
    return 'تم ⚠️ فتح 🔓 الفيديو 🎥 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الفيديوهات 🎥 بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'gi' then
			local msg_type = 'Gifs'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
    return 'تم ⚠️ فتح 🔓 المتحركه في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'المتحركه بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'dc' then
			local msg_type = 'Documents'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
    return 'تم ⚠️ فتح 🔓 الفايلات 📚 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الفايلات 📚 بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'tx' then
			local msg_type = 'Text'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute message")
					unmute(chat_id, msg_type)
    return 'تم ⚠️ فتح 🔓 الدردشه 📝 في مجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'الدردشه 📝 بالتاكيد تم ⚠️ فتحها 🔓 لمجموعتك 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
            end
			if matches[2] == 'gp' then
			local msg_type = 'All'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
    return 'تم ⚠️ فتح 🔓 المجموعه 👥\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                else
    return 'المجموعه 👥 بالتاكيد تم ⚠️ فتحها 🔓\nبواسطه 🔸--🔹 (@'..(msg.from.username or 'لا يوجد')..')\n'
                end
			end
		end


		if matches[1] == "sil" or matches[1] == "sil" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				muteuser = get_message(msg.reply_id, get_message_callback, {receiver = receiver, get_cmd = get_cmd, msg = msg})
			elseif matches[1] == "sil" or matches[1] == "sil" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
                    return "["..user_id.."] \nتـمـ⚠️ الـغـاء كـتـمـك 🔕 فـي الــمــجــمــوعــة👥"
				elseif is_momod(msg) then
					mute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
                    return "["..user_id.."] \nتـمـ☑️ كـتـمـك 🔕 فـي الــمــجــمــوعــة👥"
				end
			elseif matches[1] == "sil" or matches[1] == "sil" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

		if matches[1] == "s m" and is_momod(msg) then
			local chat_id = msg.to.id
			if not has_mutes(chat_id) then
				set_mutes(chat_id)
				return mutes_list(chat_id)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup muteslist")
			return mutes_list(chat_id)
		end
		if matches[1] == "sils" and is_momod(msg) then
			local chat_id = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup mutelist")
			return muted_user_list(chat_id)
		end

		if matches[1] == 's' and is_momod(msg) then
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup settings ")
			return show_supergroup_settingsmod(msg, target)
		end

		if matches[1] == 'ru' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group rules")
			return get_rules(msg, data)
		end

		if matches[1] == '-08-' and not is_owner(msg) then
			text = "Only managers 😐⛔️"
			reply_msg(msg.id, text, ok_cb, false)
		elseif matches[1] == 'help' and is_owner(msg) then
			local name_log = user_print_name(msg.from)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /superhelp")
			return super_help()
		end

		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Admin ["..msg.from.id.."] joined the SuperGroup via link")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Support member ["..msg.from.id.."] joined the SuperGroup")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Admin ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Support member ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^[#!/]([Aa]dd)$",
	"^[#!/]([Rr]em)$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Gg]p info)$",
	"^[#!/]([Aa]dmins)$",
	"^[#!/]([Oo]wner)$",
	"^[#!/]([Mm]ods)$",
	"^[#!/]([Bb]ots)$",
	"^[#!/]([Ww]ho)$",
	"^[#!/]([Kk]icked)$",
        "^[#!/]([Bb]b) (.*)",
	"^[#!/]([Bb]b)",
	    "^[#!/]([Kk]ick) (.*)",
	"^[#!/]([Kk]ick)",
	"^[#!/]([Tt]osuper)$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Kk]ickme)$",
	"^[#!/]([Nn]ew lk)$",
	"^[#!/]([Ss]et lk)$",
	"^[#!/]([Ll]k)$",
	"^[#!/]([Rr]es) (.*)$",
	"^[#!/]([Aa]dd admin) (.*)$",
	"^[#!/]([Aa]dd admin)",
	"^[#!/]([Dd]el admin) (.*)$",
	"^[#!/]([Dd]el admin)",
	"^[#!/]([Aa]dd owner) (.*)$",
	"^[#!/]([Aa]dd owner)$",
	"^[#!/]([Aa]dd mod) (.*)$",
	"^[#!/]([Aa]dd mod)",
	"^[#!/]([Dd]el mod) (.*)$",
	"^[#!/]([Dd]el mod)",
	"^[#!/]([Ss]et na) (.*)$",
	"^[#!/]([Ss]et ab) (.*)$",
	"^[#!/]([Ss]et ru) (.*)$",
	"^[#!/]([Ss]et ph)$",
	"^[#!/]([Ss]et us) (.*)$",
	"^[#!/]([Cc]l)$",
	"^[#!/]([Cc]) (.*)$",
	"^[#!/]([Oo]) (.*)$",
	"^[#!/]([Cc]) ([^%s]+)$",
	"^[#!/]([Oo]) ([^%s]+)$",
	"^[#!/]([Ss]il)$",
	"^[#!/]([Ss]il) (.*)$",
	"^[#!/]([Ss]il)$",
	"^[#!/]([Ss]il) (.*)$",
	"^[#!/]([Pp]ublic) (.*)$",
	"^[#!/]([Ss])$",
	"^[#!/]([Rr]u)$",
	"^[#!/]([Ss]et fl) (%d+)$",
	"^[#!/]([Cc]l) (.*)$",
	"^[#!/]([Ss] m)$",
	"^[#!/]([Ss]ils)$",
	"^([Aa]dd)$",
	"^([Rr]em)$",
	"^([Mm]ove) (.*)$",
	"^([Gg]p info)$",
	"^([Aa]dmins)$",
	"^([Oo]wner)$",
	"^([Mm]ods)$",
	"^([Bb]ots)$",
	"^([Ww]ho)$",
	"^([Kk]icked)$",
        "^([Bb]b) (.*)",
	"^([Bb]b)",
	    "^([Kk]ick) (.*)",
	"^([Kk]ick)",
	"^([Tt]osuper)$",
	"^([Ii][Dd])$",
	"^([Ii][Dd]) (.*)$",
	"^([Kk]ickme)$",
	"^([Nn]ew lk)$",
	"^([Ss]et lk)$",
	"^([Ll]k)$",
	"^([Rr]es) (.*)$",
	"^([Aa]dd admin) (.*)$",
	"^([Aa]dd admin)",
	"^([Dd]el admin) (.*)$",
	"^([Dd]el admin)",
	"^([Aa]dd owner) (.*)$",
	"^([Aa]dd owner)$",
	"^([Aa]dd mod) (.*)$",
	"^([Aa]dd mod)",
	"^([Dd]el mod) (.*)$",
	"^([Dd]el mod)",
	"^([Ss]et na) (.*)$",
	"^([Ss]et ab) (.*)$",
	"^([Ss]et ru) (.*)$",
	"^([Ss]et ph)$",
	"^([Ss]et us) (.*)$",
	"^([Cc]l)$",
	"^([Cc]) (.*)$",
	"^([Oo]) (.*)$",
	"^([Cc]) ([^%s]+)$",
	"^([Oo]) ([^%s]+)$",
	"^([Ss]il)$",
	"^([Ss]il) (.*)$",
	"^([Ss]il)$",
	"^([Ss]il) (.*)$",
	"^([Pp]ublic) (.*)$",
	"^([Ss])$",
	"^([Rr]u)$",
	"^([Ss]et fl) (%d+)$",
	"^([Cc]l) (.*)$",
	"^([Ss] m)$",
	"^([Ss]ils)$",
    "[#!/](mp) (.*)",
	"[#!/](md) (.*)",
    "^(https://telegram.me/joinchat/%S+)$",
	"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = DevPointTeam,
  pre_process = pre_process
}

--[[ 
    _____    _        _    _    _____    Dev @lIMyIl 
   |_   _|__| |__    / \  | | _| ____|   Dev @li_XxX_il
     | |/ __| '_ \  / _ \ | |/ /  _|     Dev @h_k_a
     | |\__ \ | | |/ ___ \|   <| |___    Dev @Aram_omar22
     |_||___/_| |_/_/   \_\_|\_\_____|   Dev @IXX_I_XXI
              CH > @lTSHAKEl_CH
--]]
