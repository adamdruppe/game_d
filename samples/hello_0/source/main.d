import std.stdio;
import std.conv;
import std.string;

import sandbox.core;
import sandbox.engine;
import sandbox.input;

public class MyGame : IApp
{
    public void create()
    {
        writeln("INFO: Create mey");

        // anonymous class so cool :D
        auto p = new class IInputProcessor
        {
            bool keyDown(int keycode)
            {
                writeln(format("INFO: keyDown(%s)", keycode));
                return true;
            }

            bool keyUp(int keycode)
            {
                writeln(format("INFO: keyUp(%s)", keycode));
                return false;
            }

            bool keyTyped(char character)
            {
                writeln(format("INFO: keyTyped(%s)", character));
                return false;
            }

            bool touchDown(int screenX, int screenY, int pointer, int button)
            {
                writeln(format("INFO: touchDown(%s, %s, %s, %s)", screenX,
                        screenY, pointer, button));
                return false;
            }

            bool touchUp(int screenX, int screenY, int pointer, int button)
            {
                writeln(format("INFO: touchUp(%s, %s, %s, %s)", screenX, screenY, pointer, button));
                return false;
            }

            bool touchDragged(int screenX, int screenY, int pointer)
            {
                writeln(format("INFO: touchDragged(%s, %s, %s)", screenX, screenY, pointer));
                return false;
            }

            bool mouseMoved(int screenX, int screenY)
            {
                writeln(format("INFO: mouseMoved(%s, %s)", screenX, screenY));
                return false;
            }

            bool scrolled(int amount)
            {
                writeln(format("INFO: scrolled(%s)", amount));
                return false;
            }

        };
        Core.input.setInputProcessor(p);
    }

    public void update()
    {
        //writeln(format("FPS: %s DT: %s", Core.graphics.fps(), Core.graphics.deltaTime()));
    }

    public void render()
    {
    }

    public void resize(int width, int height)
    {
    }

    public void dispose()
    {
    }
}

int main()
{
    auto game = new MyGame;
    auto engine = new Engine(game);
    engine.run();

    return 0;
}
