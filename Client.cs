using Godot;
using System;

public class Client : KinematicBody2D
{
	[Export]
	public String Desire;

	[Export]
	public Int16 Money;

	public Boolean Selected = false;
	public Boolean InStation = false;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}

	public override void _Process(float delta)
	{
		
		if(Input.IsActionPressed("left_click")) 
		{
			Selected = true;
		}
	}
}
