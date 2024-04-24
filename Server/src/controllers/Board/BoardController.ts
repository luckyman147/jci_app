//Get Board By year
import { plainToClass } from "class-transformer";
import { validate } from "class-validator";
import { Request, Response } from "express";
import { BoardInput } from "../../dto/board.dto";
import { Board } from "../../models/Board/board";
import { createPosts, getAllYearsOfBoards, getBoardsWithImages } from "../../utility/docs";
import { Post } from "../../models/Board/Post";



export const getBoardByYear = async (req: Request, res: Response) => {
  const { year } = req.params;

  try {
    const promises = [
      getBoardsWithImages(year),
      
    ];

    const results = await Promise.all(promises);

    const [boardsResult] = results;

      res.status(200).json(boardsResult);
  } catch (error) {
      console.error(error);  // Log the error for debugging
      res.status(500).json({ message: "Error retrieving board", error });
  }
};



  export const getyears= async (req: Request, res: Response) => {
  try{
    const promises = [
      getAllYearsOfBoards(),
      
    ];

    const results = await Promise.all(promises);

    const [years] = results;

    res.status(200).json(years)


  }catch(e){}
}

  export const addBoard = async (req: Request, res: Response) => {
 
  
    try {
        const Inputs = plainToClass(BoardInput, req.body);
    
      

        // Validate the inputs
        const errors = await validate(Inputs, { validationError: { target: false } });
  if (errors.length > 0) {
    return res.status(400).json({ message: 'Input validation failed', errors });
  }
  //find if exists

  const existedBoard=await Board.find({year:Inputs.year})
  if (existedBoard.length>0){
    return res.status(400).json({m:"Already Exists"})
  }
  const posts=await createPosts(Inputs.year)
  console.log(posts)
      const board = new Board({year:Inputs.year,Posts:posts });
      await board.save();
  
      res.status(201).json(board);
    } catch (error) {
      res.status(500).json({ message: "Error adding board", error });
    }
  }
  export const deleteBoard= async (req: Request, res: Response) => {
    const { id } = req.params;
  
    try {
      const board = await Board.findOne({year:id});
  
      if (board) {
        const post_ids = board.Posts;

        // Delete all posts associated with the board
        await Post.deleteMany({ _id: { $in: post_ids } });
  
        // Now delete the board
        await Board.findByIdAndDelete(board._id);
  
        res.status(204).json();
      } else {
        res.status(404).json({ message: "Board not found" });
      }
    } catch (error) {
      res.status(500).json({ message: "Error deleting board", error });
    }
  }