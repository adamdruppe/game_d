module sandbox.core;

import std.stdio;
import std.conv;
import std.string;
import core.time;
import std.datetime.stopwatch : benchmark, StopWatch, AutoStart;
import std.datetime.systime;

import bindbc.opengl;
import bindbc.glfw;

import sandbox.graphics;
import sandbox.audio;
import sandbox.input;

public class Core
{
	public static Graphics graphics;
	public static Audio audio;
	public static Input input;
}

public interface IApp
{
	void create();
	void update();
	void render();
	void resize(int width, int height);
	void dispose();
}