
import { Request, Response } from "express";
import { BoardRole } from "../../models/Board/BoardRole";
import { plainToClass } from "class-transformer";
import { BoardRoleInput } from "../../dto/board.dto";
import { validate } from "class-validator";
export const  GetAllBoardRoles= async (req:Request,res:Response)=>{

    try{
      const {priority}=req.params
        const boardRoles=await BoardRole.find({priority:priority})
        res.status(200).json(boardRoles)
    }catch(error){
        res.status(500).json({message:"Error retrieving board roles",error})
    }
}
export const AddBoardRole: any = async (req: Request, res: Response) => {
    try {
        const Inputs = plainToClass(BoardRoleInput, req.body);
    
      

        // Validate the inputs
        const errors = await validate(Inputs, { validationError: { target: false } });
  if (errors.length > 0) {
    return res.status(400).json({ message: 'Input validation failed', errors });
  }
      const boardRole = new BoardRole({ name:Inputs.name, priority:Inputs.priority });
      await boardRole.save();
      res.status(201).json(boardRole);
    } catch (error) {
      res.status(500).json({ message: "Error adding board role", error });
    }
  }
  export const DeleteBoardRole= async (req: Request, res: Response) => {
    const { id } = req.params;
  
    try {
      const boardRole = await BoardRole.findByIdAndDelete(id);
  
      if (boardRole) {
        res.status(204).json({message:"Deleted "});
      } else {
        res.status(404).json({ message: "Board role not found" });
      }
    } catch (error) {
      res.status(500).json({ message: "Error deleting board role", error });
    }
  }
  export const UpdateBoardRole = async (
    req: Request,
    res: Response
  ) => {
    const { id } = req.params;
    const Inputs = plainToClass(BoardRoleInput, req.body);
    
      

    // Validate the inputs
    const errors = await validate(Inputs, { validationError: { target: false } });
if (errors.length > 0) {
return res.status(400).json({ message: 'Input validation failed', errors });
}
  
    try {
      const boardRole = await BoardRole.findByIdAndUpdate(
        id,
        { name:Inputs.name, priority:Inputs.priority },
        { new: true }
      );
  
      if (boardRole) {
        res.status(200).json(boardRole);
      } else {
        res.status(404).json({ message: "Board role not found" });
      }
    } catch (error) {
      res.status(500).json({ message: "Error updating board role", error });
    }
  }