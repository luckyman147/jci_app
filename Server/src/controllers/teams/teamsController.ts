import { plainToClass } from "class-transformer";
import { validate } from "class-validator";
import { NextFunction, Request, Response } from "express";
import { MembersInput, TeamInputs } from "../../dto/teams.dto";
import { Event } from "../../models/activities/eventModel";
import { Team, team } from "../../models/teams/team";
import { getEventNameById, getMembersInfo, getTasksInfo } from "../../utility/role";

import { Member } from "../../models/Member";
export const AddTeam = async (req: Request, res: Response, next: NextFunction) => {
  const user=req.member
  console.log("ee"+user)
  
  try {
     console.log(req.body)
      const teamInputs=plainToClass(TeamInputs,req.body)
      const errors = await validate(teamInputs, { validationError: { target: false } });
if (errors.length > 0) {
console.log(errors);
  return res.status(400).json({ message: 'Input validation failed', errors });
}

      // Create an Event document
      const newTeam = new team({
        name: teamInputs.name,
        description: teamInputs.description,
        TeamLeader:user!._id,
        status: teamInputs.status,
        Event: teamInputs.event,
Members: Array.isArray(teamInputs.Members) ? [...teamInputs.Members, user!._id] : [user!._id],  tasks:[],CoverImage:""
      })
        

      // Add the event to the database
      const savedTeam = await newTeam.save();

    const event =await Event.findById(teamInputs.event)
  if (event) {
event.teams.push(newTeam._id)  
}

const leader=await Member.findById(user!._id)
if (leader){
  leader.Teams.push(newTeam.id)
}
await leader?.save()
await event?.save()
const show=await  showTeamDetails(savedTeam)
res.json(show);
    } catch (error) {
      console.log('Error adding event:', error);
      next(error);
    }}
export const GetTeams = async (req: Request, res: Response, next: NextFunction) => {
    const start: number = parseInt(req.query.start as string);
    const limit: number = parseInt(req.query.limit as string);
    const memberid=req.member!._id
    const IsPrivate=req.query.isPrivate as string

    let bollean=false
    if (IsPrivate=="true"){
      bollean=true
    }

    const startIndex: number = start;
    const endIndex: number = start + limit;

    const results: any = {};

    if (endIndex < await team.countDocuments().exec()) {
        results.next = {
            start: endIndex,
            limit: limit
        };
    }

    if (startIndex > 0) {
        results.previous = {
            start: Math.max(start - limit, 0), // Ensure start is not negative
            limit: limit
        };
    }
    
      if (IsPrivate=="false"){
        const teams = await team.find({status:true}).sort({ createdAt: 'desc' }) .limit(limit).skip(startIndex).exec();
if (teams.length > 0) {
         const teamsWithEvent = await Promise.all(
                    teams.filter(team => team.status == true) // Filtering teams with status true
                        .map(async (team) => ({
                            id: team._id,
                            event: await getEventNameById(team.Event),
                            description: team.description,
                            TeamLeader: await getMembersInfo([team.TeamLeader]),
                            name: team.name,
                            status: team.status,
                            CoverImage: team.CoverImage,
                            tasks: await getTasksInfo(team.tasks),
                            Members: await getMembersInfo(team.Members),
                        }))
                );
    
        results.results = teamsWithEvent;
        res.status(200).json(results);}


else{
  res.status(404).json({ message: "No teams found" });
}




      }


       else{
        const teams = await team.find({status:false,Members:memberid}).sort({ createdAt: 'desc' }) .limit(limit).skip(startIndex).exec();

   if (teams.length > 0) {
   console.log(memberid)
        const teamsWithEvent = await Promise.all(
            
          teams.map(async (team) => ({
                id: team._id,
                event: await getEventNameById(team.Event),
                description: team.description,
                TeamLeader: await getMembersInfo([team.TeamLeader]),
                name: team.name,
                status: team.status,
                
                CoverImage: team.CoverImage,
                tasks: await getTasksInfo(team.tasks),
                Members: await getMembersInfo(team.Members),
            }))
        );

   
        results.results = teamsWithEvent;
       
        res.status(200).json(results);}
        else{
          res.status(404).json({ message: "No teams found" });
        }


};

}
export const getTeamById = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const id = req.params.id;
      const Team = await team.findById(id);
      if (Team) {
// Convert the base64 string to a Buffer
const show=await  showTeamDetails(Team)

        res.json(show);
       
      } else {
  
        res.status(404).json({ message: "No team found with this id" });
      }
    } catch (error) {
      console.error('Error retrieving team by id:', error);
      next(error);
    }
    
  }
  export  const getTeamByName= async (req: Request, res: Response, next: NextFunction) => {
    const name = req.query.name as string;
   
   const memberid=req.member!._id

    try {
      const teams = await team.find({
        $or: [
            { status: true },
            { 
                status: false,
                Members: memberid
            }
        ],
        name: { $regex: name, $options: 'i' } // Regex pattern on the name field
    }).sort({ createdAt: 'desc' }).limit(5)

      if (teams.length > 0) {
       
        const StatusTeam=teams.filter((team)=>team.status==true)
      
        const show = await Promise.all(StatusTeam.map(showTeamDetails));
        res.status(200).json(show);
      
      
       
      } else {
        res.status(404).json({ message: "No teams found with this name" });
      }
    } catch (error) {
      console.error("Error retrieving team by name:", error);
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
const show=await  showTeamDetails(savedTeam)
  
      res.status(200).json(show);
    } catch (error) {
      res.status(500).json({ error: error});
    }
  };  
  export const updateImage = async (req: Request, res: Response, next: NextFunction) => {
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
      existingTeam.Event = teamInputs.event;
      existingTeam.Members = teamInputs.Members;
      existingTeam.tasks = teamInputs.tasks;
      existingTeam.status = teamInputs.status;
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
  //TODO add member





export const addMember=async (req:Request,res:Response,next:NextFunction)=>{
  try {
    const teamId = req.params.id;
    const memberId=req.params.memberId
 ;

    // Check if the team exists
    const Team = await team.findById(teamId);
    if (!Team) {
      return res.status(404).json({ error: 'Team not found' });
    }

  const member=await Member.findById(memberId)
  if (!member) {
    return res.status(404).json({ error: 'Member not found' });
  }

    // Add the member to the team's members array
    Team.Members.push(member._id);
member.Teams.push(Team.id)
    // Save the updated team
    const updatedTeam = await Team.save();

    res.status(201).json({ member: member, team: updatedTeam });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
}

const showTeamDetails = async (team:Team) => {
  try {
    const result = {
      id: team._id,
      event: await getEventNameById(team.Event),
      description: team.description,
      TeamLeader: await getMembersInfo([team.TeamLeader]),
      name: team.name,
      status: team.status,
      CoverImage: team.CoverImage,
      tasks: await getTasksInfo(team.tasks),
      Members: await getMembersInfo(team.Members),
    };
    return result;
  } catch (error) {
    console.error("Error in showTeamDetails:", error);
    throw error;
  }}







  export const UpdateTeamMembers = async (req: Request, res: Response, next: NextFunction) => {
    try {
      
      const teamId = req.params.teamid;
      const user=req.member?._id
  
      const Team = await team.findById(teamId);
      if (!Team) {
        return res.status(404).json({ error: 'team not found' });
      }
    const membersInput = plainToClass(MembersInput, req.body);
      const errors = await validate(membersInput, { validationError: { target: false } });
      if (errors.length > 0) {
        return res.status(400).json({ message: 'Input validation failed', errors });
      }
         console.log(membersInput.Status)  
 //invite members
if (membersInput.Status=="add"){

  console.log(membersInput.Member)  
  console.log(membersInput.Status)  
   
  await Team.Members.push(membersInput.Member)

    await Team.save()
    const member=await Member.findById(membersInput.Member)
    if (member){
member.Teams.push(Team._id)
await member?.save()
    }
      res.status(200).json({ message:"Completed" , Team });
}
//kick Member
else  if (membersInput.Status == "kick") {
  console.log(membersInput.Member)

  Team.Members = Team.Members.filter((member) => member._id.toString() !== membersInput.Member.toString());

await Team.save()
const member=await Member.findById(membersInput.Member)
    if (member){
member.Teams=member.Teams.filter((mem)=>  mem.toString()!==Team._id.toString())
await member?.save()
    }    

res.status(200).json({ message:"Completed" , Team });
  
}
else{
  //exit 
  
  Team.Members = Team.Members.filter((member) => member._id.toString() !== user);
  const member=await Member.findById(user)
  if (member){
member.Teams=member.Teams.filter((team)=> team.toString()!=Team._id.toString())
await member?.save()
  }
await Team.save()
    res.status(200).json({ message:"Completed" , Team });
}
}
   
    
    catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  
  
  
  