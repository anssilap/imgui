baseName = path.getbasename(os.getcwd());

function get_imgui_dir()
    return "imgui"
end

imgui_dir = get_imgui_dir();

function link_imgui()
    includedirs {
        "../" .. imgui_dir,
        "../" .. imgui_dir .. "/backends",
    }

    filter "action:vs*"
        dependson {"imgui"}
        links {"imgui.lib"}

    filter "system:windows"
        libdirs {"../_bin/%{cfg.buildcfg}"}
end

group "External dependecies"
	project "imgui"
		kind "StaticLib"
		language "C++"

        includedirs {
            "../" .. imgui_dir,
            "../" .. imgui_dir .. "/backends",
            "../" .. glfw_dir .."/include",
        }

        vpaths
        {
            ["Header Files/*"] = {"backends/**.h",  "backends/**.hpp", "**.h", "**.hpp"},
            ["Source Files/*"] = {"backends/**.c", "backends/**.cpp", "**.c", "**.cpp"},
        }
        files {
            "./premake5.lua",
            "*.h",
            "*.cpp",
            "./backends/imgui_impl_glfw.cpp",
            "./backends/imgui_impl_glfw.h",
            "./backends/imgui_impl_opengl3.cpp",
            "./backends/imgui_impl_opengl3.h"
        }

        location ("../_project")
        targetdir "../_bin/%{cfg.buildcfg}"

        filter "system:windows"
			systemversion "latest"
			staticruntime "On"

		filter "configurations:Debug"
			runtime "Debug"
			symbols "on"

		filter "configurations:Release"
			runtime "Release"
			optimize "on"

        link_glfw()
group "" -- End of dependencies
