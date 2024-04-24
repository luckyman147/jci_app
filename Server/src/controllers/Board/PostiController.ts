import { plainToClass } from "class-transformer";
import { validate } from "class-validator";
import { Request, Response } from "express";
import { PostInput } from "../../dto/board.dto";
import { Post } from "../../models/Board/Post";
import { Board } from "../../models/Board/board";
import { Member } from "../../models/Member";

export const AddPost=async(req:Request,res:Response)=>{
  


    try {
        const Inputs = plainToClass(PostInput, req.body);
    
      

        // Validate the inputs
        const errors = await validate(Inputs, { validationError: { target: false } });
  if (errors.length > 0) {
    return res.status(400).json({ message: 'Input validation failed', errors });
  }
    // Check if post with the same year, role, and Assignto exists

  

        const post = new Post({year:Inputs.year,role:Inputs.role,Assignto:Inputs.assignto });
        await post.save();
        const board = await Board.findOneAndUpdate(
            { year: Inputs.year }, // find by year
            { $push: { Posts: post.id } }, // push new post.id to Posts array
            { new: true } // return the updated document
          );

          if (board){


        res.status(201).json({post:post,board:board});}
        else{
res.status(400).json('Error Adding position')
        }
      } catch (error) {
        res.status(500).json({ message: "Error adding post", error });
      }
}
export const DeletePost= async (req: Request, res: Response) => {
    const { id,year } = req.params;
    
    try {
        const post = await Post.findByIdAndDelete(id);
        if (post ){
        const board = await Board.findOneAndUpdate(
            { year: year }, // find by year
            { $pull: { Posts: id } }, // update Posts field
      
          );

          if (board){


        res.status(204).json({board:board});}
        else{
res.status(400).json('Error eleteting position')
        }}
        else{
       
            res.status(404).json({ message: "Post not found" });
        
        }
    } catch (error) {
        res.status(500).json({ message: "Error deleting post", error });
    }
    }

export const AddAssignTo = async ( req: Request, res: Response) => {
    const { id } = req.params;
    const { assignTo } = req.body;
  
    try {
      const post = await Post.findById(id );

      const member=await Member.findById(assignTo)
if (!post){
    res.status(404).json({ message: "Post not found" });
}
else if (!member){

    res.status(404).json({ message: "Member  not found" });

}
       else {
            post.Assignto=[assignTo];
            await post.save();
            res.status(200).json(post);
        } 
    
    }
catch (e){
    res.status(500).json({ message: "Error adding assignTo", e });

}

}
export const RemoveAssignTo = async ( req: Request, res: Response) => {
    const { id } = req.params;
    const { assignTo } = req.body;
  
    try {
      const post = await Post.findById(id );
      const member=await Member.findById(assignTo)

      if (!post){
        res.status(404).json({ message: "Post not found" });
    }
    else if (!member){
    
        res.status(404).json({ message: "Member  not found" });
    
    }
        if (post) {
           post.Assignto = post.Assignto.filter((assign) => assign != assignTo);
            await post.save();
            console.log(post)
            res.status(204).json(post);
        } 
    
    }
catch (e){
    res.status(500).json({ message: "Error removing assignTo", e });

}

}
export const UpdatePost = async (
    req: Request,
    res: Response
  ) => {
    const { id } = req.params;
    const Inputs = plainToClass(PostInput, req.body);
    
      

    // Validate the inputs
    const errors = await validate(Inputs, { validationError: { target: false } });
if (errors.length > 0) {
    return res.status(400
        ).json({ message: 'Input validation failed', errors });
    }
    let post = await Post.findByIdAndUpdate(id, {role:Inputs.role},

    )
    if (post){
        res.status(200).json(post);
    }else{
        res.status(404).json({message: "Post not found"});
    }

}
