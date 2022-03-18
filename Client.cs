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

	}

	// GD.Print("clickfqsfsqdfqsf");

	private void _on_Client_input_event(object viewport, object @event, int shape_idx)
	{
		GD.Print("clickfqsfsqdfqsf");
	}

}

