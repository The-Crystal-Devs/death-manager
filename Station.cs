using Godot;
using System;

public class Station : Area2D
{

	public Boolean Selected = false;	

	[Export]
	public Int16 duration;

	public String type;
	
	public override void _Ready()
	{
		
	}

	public override void _Process(float delta) 
	{
				
	}

	private void _on_StationPossiblePosition_pressed()
	{
		if(Selected) 
		{
			
		}
	}

}
