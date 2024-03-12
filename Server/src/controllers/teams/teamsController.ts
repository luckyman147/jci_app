import { plainToClass } from "class-transformer";
import { validate } from "class-validator";
import { NextFunction, Request, Response } from "express";
import { TeamInputs } from "../../dto/teams.dto";
import { Event } from "../../models/activities/eventModel";
import { team } from "../../models/teams/team";
import { getMembersInfo, getTeamByEvent } from "../../utility/role";

import zlib from "zlib";
export const AddTeam = async (req: Request, res: Response, next: NextFunction) => {
    try {
      // Extract data from the request body
      const teamInputs=plainToClass(TeamInputs,req.body)
      const errors = await validate(teamInputs, { validationError: { target: false } });
if (errors.length > 0) {
  return res.status(400).json({ message: 'Input validation failed', errors });
}

      // Create an Event document
      const newTeam = new team({
        name: teamInputs.name,
        description: teamInputs.description,
        Event: teamInputs.Event,
      Members:teamInputs.Members,
      tasks:[],CoverImage:""
      })
        

      // Add the event to the database
      const savedTeam = await newTeam.save();
    const event =await Event.findById(teamInputs.Event)
  if (event) {
event.teams.push(newTeam._id)  
}
      res.json(savedTeam);
    } catch (error) {
      console.log('Error adding event:', error);
      next(error);
    }}
export const GetTeams= async (req:Request,res:Response,next:NextFunction)=>{
    const grouped=req.query.grouped
    if (grouped) {
        try{
     const teams= await getTeamByEvent()
     if (teams.length>0) {
         res.status(200).json(teams)
     }
        else{
            res.status(404).json({error:"No teams found"})
        }
    
    }catch{
        res.status(500).json({error:"Internal server error"})
    }
    }
    else{
       const teams= await team.find()
        if ( teams.length>0) {
          const teamsWithEvent = teams.map((team) => ({
            id: team._id,
            event:team.Event.name,
            name: team.name,
            tasks:team.tasks,
            members:getMembersInfo(team.Members),
          }));
            res.status(200).json(
              
teamsWithEvent
            )
        }
        else{
            res.status(404).json({error:"No teams found"})
        }
    }
}



export const getTeamById = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const id = req.params.id;
      const Team = await team.findById(id);
      if (Team) {
// Convert the base64 string to a Buffer
const bufferData = Buffer.from(Team.CoverImage, 'base64');

// Compress the Buffer using zlib
const compressedData = zlib.deflateSync(bufferData);
        res.json({
  
          _id: Team._id,
          name: Team.name,
       
          description: Team.description,
       
        members:await  getMembersInfo( Team.Members),
          tasks: Team.tasks,
          CoverImage: compressedData,
        });
       
      } else {
  
        res.status(404).json({ message: "No team found with this id" });
      }
    } catch (error) {
      console.error('Error retrieving team by id:', error);
      next(error);
    }
    
  }
  
export const uploadTeamImage = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const teamId = req.params.id;
      const Team = await team.findById(teamId);
  
      if (!Team) {
        return res.status(404).send("No such team");
      }
  
      const image = req.file as Express.Multer.File;
  
      if (!image) {
        return res.status(400).send("Invalid or missing image file");
      }
  
      // Convert the image to base64
      const base64Image = image.buffer.toString('base64');
  
      // Add the image to the team
      Team.CoverImage = base64Image;
  
      // Save the team
      const savedTeam = await Team.save();
  
      res.status(200).json(savedTeam);
    } catch (error) {
      res.status(500).json({ error: error});
    }
  };  export const updateImage = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const teamId = req.params.id;
      const Team = await team.findById(teamId);
  
      if (!Team) {
        return res.status(404).send("No such team");
      }
  
      const image = req.file as Express.Multer.File;
  
      if (!image) {
        return res.status(400).send("Invalid or missing image file");
      }
  
      // Convert the image to base64
      const base64Image = image.buffer.toString('base64');
  
      // Add the image to the team
      Team.CoverImage = base64Image;
  
      // Save the team
      const savedTeam = await Team.save();
  
      res.status(200).json(savedTeam);
    } catch (error) {
      res.status(500).json({ error: "errrr"});
    }
  }
  export const updateTeam = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const TeamId = req.params.id;
  
      // Find the existing Team by ID
      const existingTeam = await team.findById(TeamId);
  
      if (!existingTeam) {
        return res.status(404).json({ message: 'Team not found' });
      }
  
      // Extract data from the request body
      const teamInputs = plainToClass(TeamInputs, req.body);
      const errors = await validate(teamInputs, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }  
      // Update the existing Team properties
      existingTeam.name = teamInputs.name;
      existingTeam.description = teamInputs.description;
      existingTeam.Event = teamInputs.Event;
      existingTeam.Members = teamInputs.Members;
      existingTeam.tasks = teamInputs.tasks;
      const updatedTeam = await existingTeam.save();
  
      res.json(updatedTeam);
    } catch (error) {
      console.error('Error updating Team:', error);
      next(error);
    }
  }

  export const deleteTeam= async (req:Request, res:Response, next:NextFunction) => {
    try {
      const TeamId = req.params.id;

      // Check if the Team exists
      const Team = await team.findById(TeamId);
      if (!Team) {
        return res.status(404).json({ error: 'Team not found' });
      }

      // Delete the Team
      await Team.deleteOne();

      res.status(204).json({message:"deleted successully"}); // 204 No Content indicates a successful deletion
    } catch (error) {
      console.error('Error deleting event:', error);
      next(error);
    }
  };


