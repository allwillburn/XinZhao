local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "XinZhao" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/XinZhao/master/XinZhao.lua', SCRIPT_PATH .. 'XinZhao.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/XinZhao/master/XinZhao.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local XinZhaoMenu = Menu("XinZhao", "XinZhao")

XinZhaoMenu:SubMenu("Combo", "Combo")

XinZhaoMenu.Combo:Boolean("Q", "Use Q in combo", true)
XinZhaoMenu.Combo:Boolean("W", "Use W in combo", true)
XinZhaoMenu.Combo:Boolean("E", "Use E in combo", true)
XinZhaoMenu.Combo:Boolean("R", "Use R in combo", true)
XinZhaoMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
XinZhaoMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
XinZhaoMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
XinZhaoMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
XinZhaoMenu.Combo:Boolean("RHydra", "Use RHydra", true)
XinZhaoMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
XinZhaoMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
XinZhaoMenu.Combo:Boolean("Randuins", "Use Randuins", true)


XinZhaoMenu:SubMenu("AutoMode", "AutoMode")
XinZhaoMenu.AutoMode:Boolean("Level", "Auto level spells", false)
XinZhaoMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
XinZhaoMenu.AutoMode:Boolean("Q", "Auto Q", false)
XinZhaoMenu.AutoMode:Boolean("W", "Auto W", false)
XinZhaoMenu.AutoMode:Boolean("E", "Auto E", false)
XinZhaoMenu.AutoMode:Boolean("R", "Auto R", false)

XinZhaoMenu:SubMenu("LaneClear", "LaneClear")
XinZhaoMenu.LaneClear:Boolean("Q", "Use Q", true)
XinZhaoMenu.LaneClear:Boolean("W", "Use W", true)
XinZhaoMenu.LaneClear:Boolean("E", "Use E", true)
XinZhaoMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
XinZhaoMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

XinZhaoMenu:SubMenu("Harass", "Harass")
XinZhaoMenu.Harass:Boolean("Q", "Use Q", true)
XinZhaoMenu.Harass:Boolean("W", "Use W", true)

XinZhaoMenu:SubMenu("KillSteal", "KillSteal")
XinZhaoMenu.KillSteal:Boolean("Q", "KS w Q", true)
XinZhaoMenu.KillSteal:Boolean("E", "KS w E", true)

XinZhaoMenu:SubMenu("AutoIgnite", "AutoIgnite")
XinZhaoMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

XinZhaoMenu:SubMenu("Drawings", "Drawings")
XinZhaoMenu.Drawings:Boolean("DE", "Draw E Range", true)

XinZhaoMenu:SubMenu("SkinChanger", "SkinChanger")
XinZhaoMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
XinZhaoMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if XinZhaoMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if XinZhaoMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 600) then
				if target ~= nil then 
                                      CastSpell(_Q)
                                end
            end

            if XinZhaoMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 600) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if XinZhaoMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if XinZhaoMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if XinZhaoMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if XinZhaoMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if XinZhaoMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
			 CastTargetSpell(target, _E)
	    end

            if XinZhaoMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 600) then
		     if target ~= nil then 
                         CastSpell(_Q)
                     end
            end

            if XinZhaoMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if XinZhaoMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if XinZhaoMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if XinZhaoMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 600) then
			CastSpell(_W)
	    end
	    
	    
            if XinZhaoMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 187) and (EnemiesAround(myHeroPos(), 187) >= XinZhaoMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 600) and XinZhaoMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSpell(_Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and XinZhaoMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target, _E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if XinZhaoMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 600) then
	        	CastTargetSpell(_Q)
                end

                if XinZhaoMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 600) then
	        	CastSpell(_W)
	        end

                if XinZhaoMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastTargetSpell(target, _E)
	        end

                if XinZhaoMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if XinZhaoMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if XinZhaoMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 600) then
		      CastSpell(_Q)
          end
        end 
        if XinZhaoMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 600) then
	  	      CastSpell(_W)
          end
        end
        if XinZhaoMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 125) then
		      CastTargetSpell(target, _E)
	  end
        end
        if XinZhaoMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 187) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if XinZhaoMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if XinZhaoMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), 600, 0, 200, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
           

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if XinZhaoMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>XinZhao</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





