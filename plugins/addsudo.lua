
--[[ 
    _____    _        _    _    _____    Dev @lIMyIl 
   |_   _|__| |__    / \  | | _| ____|   Dev @li_XxX_il
     | |/ __| '_ \  / _ \ | |/ /  _|     Dev @h_k_a
     | |\__ \ | | |/ ___ \|   <| |___    Dev @Aram_omar22
     |_||___/_| |_/_/   \_\_|\_\_____|   Dev @IXX_I_XXI
              CH > @lTSHAKEl_CH
--]]
local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 
 
function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end 
   function h_k_a(msg, matches) 
    if tonumber (msg.from.id) == 67369633 then 
       if matches[1]:lower() == "addsudo" then 
          table.insert(_config.sudo_users, tonumber(matches[2])) 
      print(matches[2] ..' تم اضافه مطور جديد في البوت') 
     save_config() 
     reload_plugins(true) 
      return matches[2] ..' تم اضافه مطور جديد في البوت' 
   elseif matches[1]:lower() == "delsudo" then 
      local k = tonumber(matches[2]) 
          table.remove(_config.sudo_users, getindex( _config.sudo_users, k)) 
      print(matches[2] ..' تم حذف المطور من البوت') 
     save_config() 
     reload_plugins(true) 
      return matches[2] ..' تم حذف المطور من البوت' 
      end 
   end 
end 
return { 
patterns = { 
"^(addsudo) (%d+)$", 
"^(delsudo) (%d+)$",
"^[#!/](addsudo) (%d+)$", 
"^[#!/](delsudo) (%d+)$"
}, 
run = h_k_a 
}

-- تم التعديل و التعريب بواسطه @h_k_a

--[[ 
    _____    _        _    _    _____    Dev @lIMyIl 
   |_   _|__| |__    / \  | | _| ____|   Dev @li_XxX_il
     | |/ __| '_ \  / _ \ | |/ /  _|     Dev @h_k_a
     | |\__ \ | | |/ ___ \|   <| |___    Dev @Aram_omar22
     |_||___/_| |_/_/   \_\_|\_\_____|   Dev @IXX_I_XXI
              CH > @lTSHAKEl_CH
--]]
