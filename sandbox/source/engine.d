module sandbox.engine;

import bindbc.opengl;
import bindbc.glfw;

import sandbox.core;
import sandbox.graphics;
import sandbox.audio;
import sandbox.input;

public class Engine
{
	private Graphics _graphics;
	private Audio _audio;
	private Input _input;
	private IApp _app;

	private bool _running = true;
	
	public this(IApp app)
	{
		_app = app;
	}

	public void run()
	{
		_graphics = new Graphics(_app);
		_audio = new Audio;
		_input = new Input;
        
		Core.graphics = _graphics;
		Core.audio = _audio;
		Core.input = _input;


		_graphics.createContext();
        _input.windowHandleChanged(_graphics.windowHandle());

		while(_running)
		{
			// runables

			if(!_graphics.isIconified())
				_input.update();

			_graphics.update();


			if(!_graphics.isIconified())
				_input.prepareNext();

			_running = !_graphics.shouldClose();
			
			glfwPollEvents();
		}

		glfwTerminate();
		
		_app.dispose();
	}

	public void exit()
	{
		_running = false;
	}
}
