if CLIENT then
	local tte_enabled = CreateClientConVar ("pp_toytownextra", "0", true, false)
	local tte_passes = CreateClientConVar ("pp_toytownextra_passes", "1", true, false)
	local tte_size = CreateClientConVar ("pp_toytownextra_size", "5", true, false)
	local tte_left = CreateClientConVar ("pp_toytownextra_left", "1", true, false)
	local tte_right = CreateClientConVar ("pp_toytownextra_right", "1", true, false)
	local tte_top = CreateClientConVar ("pp_toytownextra_top", "1", true, false)
	local tte_down = CreateClientConVar ("pp_toytownextra_down", "1", true, false)
	
	list.Set("PostProcess", "ToyTown Extra", {
		icon = "gui/postprocess/tte.jpg",
		convar = "pp_toytownextra",
		category = "#shaders_pp",
		cpanel = function(CPanel)
		
			local params = {
				Options = {},
              	CVars = {},
              	MenuButton = "1",
				Folder = "toytownextra"
			}

			params.Options["#preset.default"] = {
				pp_toytownextra_passes = "1",
				pp_toytownextra_size = "5",
				pp_toytownextra_left = "1",
				pp_toytownextra_right = "1",
				pp_toytownextra_top = "1",
				pp_toytownextra_down = "1"
			}	
	
			params.CVars = table.GetKeys(params.Options["#preset.default"])
			CPanel:AddControl("ComboBox", params)
	
			CPanel:AddControl("CheckBox", { 
				Label = "Enable", 
				Command = "pp_toytownextra" 
			})
			
			CPanel:AddControl("Slider", {
				Label = "Passes",
				Command = "pp_toytownextra_passes",
				Type = "Integer",
				Min = "0",
				Max = "10"
			})
			
			CPanel:AddControl("Slider", {
				Label = "Size",
				Command = "pp_toytownextra_size",
				Type = "Float",
				Min = "0",
				Max = "10"
			})
			
			CPanel:AddControl("CheckBox", { 
				Label = "Left side", 
				Command = "pp_toytownextra_left" 
			})
			
			CPanel:AddControl("CheckBox", { 
				Label = "Right ride", 
				Command = "pp_toytownextra_right" 
			})
			
			CPanel:AddControl("CheckBox", { 
				Label = "Top side", 
				Command = "pp_toytownextra_top" 
			})
			
			CPanel:AddControl("CheckBox", { 
				Label = "Bottom side", 
				Command = "pp_toytownextra_down" 
			})
		end
	})
	
	local bluraxisy = Material( "toytownextra/toytowny" )
	bluraxisy:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
	local bluraxisx = Material( "toytownextra/toytownx" )
	bluraxisx:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

	function DrawToyTownXY( BlurPasses, H, W )
		cam.Start2D()
		surface.SetMaterial( bluraxisy )
		surface.SetDrawColor( 255, 255, 255, 255 )	
		for i = 1, BlurPasses do
			render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )
			if ( tte_down:GetBool() ) then
				surface.DrawTexturedRectUV( 0, ScrH()-H, ScrW(), H, 0, 1, 0, 0) -- down
			end
			if ( tte_top:GetBool() ) then
				surface.DrawTexturedRectUV( 0, 0       , ScrW(), H, 0, 0, 0, 1) -- top
			end
		end
		cam.End2D()
		-- ( number x, number y, number width, number height, number startU, number startV, number endU, number endV )
		cam.Start2D()
		surface.SetMaterial( bluraxisx )
		surface.SetDrawColor( 255, 255, 255, 255 )	
		for i = 1, BlurPasses do
			render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )
			if ( tte_right:GetBool() ) then
				surface.DrawTexturedRectUV( ScrW()-W, 0, W, ScrH(), 1, 0, 0, 0) -- right
			end
			if ( tte_left:GetBool() ) then
				surface.DrawTexturedRectUV( 0,        0, W, ScrH(), 0, 0, 1, 0) -- left	
			end
		end
		cam.End2D()
	end

	hook.Add( "RenderScreenspaceEffects", "ToyTownExtra", function()
		if ( !tte_enabled:GetBool() ) then return end
		local BlurPasses = tte_passes:GetInt()
		local SizePasses = tte_size:GetFloat()
		local H = math.floor( 100*SizePasses )
		local W = math.floor( 100*SizePasses )
		DrawToyTownXY( BlurPasses, H , W )
	end)
end