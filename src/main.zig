const std = @import("std");
const c = @cImport({
    @cDefine("CIMGUI_DEFINE_ENUMS_AND_STRUCTS", {});
    @cDefine("CIMGUI_USE_SDL2", {});
    @cInclude("cimgui.h");
    @cInclude("cimgui_impl.h");

    @cInclude("SDL2/SDL.h");
});

pub fn main() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO | c.SDL_INIT_TIMER | c.SDL_INIT_GAMECONTROLLER) != 0) @panic("sdl error");
    _ = c.SDL_SetHint(c.SDL_HINT_IME_SHOW_UI, "1");

    var window = c.SDL_CreateWindow(
        "imgui",
        c.SDL_WINDOWPOS_UNDEFINED,
        c.SDL_WINDOWPOS_UNDEFINED,
        500,
        500,
        c.SDL_WINDOW_SHOWN | c.SDL_WINDOW_RESIZABLE,
    ) orelse @panic("sdl error");

    var renderer = c.SDL_CreateRenderer(
        window,
        -1,
        c.SDL_RENDERER_ACCELERATED,
    ) orelse @panic("sdl error");

    _ = c.igCreateContext(null);
    c.igStyleColorsDark(null);

    if(!c.ImGui_ImplSDL2_InitForSDLRenderer(window, renderer)) @panic("cimgui error");
    if(!c.ImGui_ImplSDLRenderer2_Init(renderer)) @panic("cimgui error");

    var show_demo_window = true;
    var asdf = true;
    _ = asdf;

    game_loop: while (true) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            _ = c.ImGui_ImplSDL2_ProcessEvent(&event);
            if (event.type == c.SDL_QUIT) {
                break :game_loop;
            }
        }

        _ = c.ImGui_ImplSDLRenderer2_NewFrame();
        _ = c.ImGui_ImplSDL2_NewFrame();
        _ = c.igNewFrame();
        _ = c.igShowDemoWindow(&show_demo_window);

        _ = c.igRender();
        _ = c.SDL_RenderClear(renderer);
        _ = c.ImGui_ImplSDLRenderer2_RenderDrawData(c.igGetDrawData());
        _ = c.SDL_RenderPresent(renderer);
    }
}
