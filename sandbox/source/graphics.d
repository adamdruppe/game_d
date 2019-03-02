module sandbox.graphics;

import std.stdio;
import std.conv;
import std.string;
import std.datetime.stopwatch : benchmark, StopWatch, AutoStart;

import bindbc.opengl;
import bindbc.glfw;

import sandbox.core;

extern (C) void onFrameBufferResize(GLFWwindow* window, int width, int height) nothrow
{
	try
	{
		//writeln(format("EVENT: onResize(%s, %s)", width, height));

		Core.graphics.updateBackbufferInfo();

		if (!Core.graphics.isInitialized())
		{
			return;
		}
		glViewport(0, 0, width, height);

		Core.graphics.getApp().resize(width, height);

		glfwSwapBuffers(window);
	}
	catch (Exception e)
	{

	}
}

public enum HdpiMode
{
	Logical,
	Pixels
}

public class Graphics
{
	private GLFWwindow* _window;
	private int _width = 1280;
	private int _height = 720;
	private int _backBufferWidth;
	private int _backBufferHeight;
	private int _logicalWidth;
	private int _logicalHeight;

	private HdpiMode _hdpiMode = HdpiMode.Logical;

	private bool _iconified = false;

	private StopWatch _sw;
	private long _lastFrameTime = -1;
	private float _deltaTime;
	private long _frameId;
	private long _frameCounterStart = 0;
	private int _frames;
	private int _fps;

	private IApp _app;

	private bool _initialized;

	public this(IApp app)
	{
		_app = app;
		_sw = StopWatch(AutoStart.yes);
	}

	private void updateBackbufferInfo()
	{
		glfwGetFramebufferSize(_window, &_backBufferWidth, &_backBufferHeight);
		glfwGetWindowSize(_window, &_logicalWidth, &_logicalHeight);
	}

	public bool createContext()
	{
		GLFWSupport ret = loadGLFW();

		if (ret != glfwSupport)
		{

			// Handle error. For most use cases, its reasonable to use the the error handling API in
			// bindbc-loader to retrieve error messages for logging and then abort. If necessary, it's 
			// possible to determine the root cause via the return value:

			if (ret == GLFWSupport.noLibrary)
			{

				writeln("ERROR: unable to find glfw3 library");
			}
			else if (GLFWSupport.badLibrary)
			{
				// One or more symbols failed to load. The likely cause is that the
				// shared library is for a lower version than bindbc-glfw was configured
				// to load (via GLFW_31, GLFW_32 etc.)
				writeln("ERROR: wrong library shit");
			}
		}

		if (!glfwInit())
			return false;

		glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
		glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
		glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
		glfwWindowHint(GLFW_RESIZABLE, GL_TRUE);

		_window = glfwCreateWindow(_width, _height, "Hi D", null, null);
		if (!_window)
		{
			glfwTerminate();
			return false;
		}

		glfwMakeContextCurrent(_window);
		glfwSwapInterval(1);

		updateBackbufferInfo();

		GLSupport retVal = loadOpenGL();

		writefln("Vendor:    %s", to!string(glGetString(GL_VENDOR)));
		writefln("Renderer:  %s", to!string(glGetString(GL_RENDERER)));
		writefln("Version:   %s", to!string(glGetString(GL_VERSION)));
		writefln("GLSL:      %s", to!string(glGetString(GL_SHADING_LANGUAGE_VERSION)));
		writefln("Loaded GL: %s", to!string(retVal));

		glViewport(0, 0, _width, _height);

		glfwSetFramebufferSizeCallback(_window, &onFrameBufferResize);
		return true;
	}

	public void update()
	{
		if (!_initialized)
		{
			_app.create();
			_app.resize(_backBufferWidth, _backBufferHeight);
			_initialized = true;
		}

		track();
		_app.update();
		_app.render();
		glfwSwapBuffers(_window);
	}

	void track()
	{
		// auto curr = MonoTime.currTime;
		// auto time = curr.ticks;

		auto time = _sw.peek.total!"nsecs";

		if (_lastFrameTime == -1)
			_lastFrameTime = time;

		_deltaTime = (time - _lastFrameTime) / 1000000000.0f;
		_lastFrameTime = time;

		if (time - _frameCounterStart >= 1000000000)
		{
			_fps = _frames;
			_frames = 0;
			_frameCounterStart = time;
		}

		_frames++;
		_frameId++;
	}

	public bool shouldClose()
	{
		auto _ = to!bool(glfwWindowShouldClose(_window));
		return _;
	}

	public float deltaTime()
	{
		return _deltaTime;
	}

	public int fps()
	{
		return _fps;
	}

	public GLFWwindow* windowHandle()
	{
		return _window;
	}

	public IApp getApp()
	{
		return _app;
	}

	public bool isInitialized()
	{
		return _initialized;
	}

	public bool isIconified()
	{
		return _iconified;
	}

	public HdpiMode getHdpiMode()
	{
		return _hdpiMode;
	}

	public int getWidth()
	{
		if (_hdpiMode == HdpiMode.Pixels)
		{
			return _backBufferWidth;
		}
		else
		{
			return _logicalWidth;
		}
	}

	public int getHeight()
	{
		if (_hdpiMode == HdpiMode.Pixels)
		{
			return _backBufferHeight;
		}
		else
		{
			return _logicalHeight;
		}
	}

	public int getBackBufferWidth()
	{
		return _backBufferWidth;
	}

	public int getBackBufferHeight()
	{
		return _backBufferHeight;
	}

	public int getLogicalWidth()
	{
		return _logicalWidth;
	}

	public int getLogicalHeight()
	{
		return _logicalHeight;
	}
}
