import { Board } from "../models/Board/board";

import { Request } from 'express';
import { BoardRole } from "../models/Board/BoardRole";
import { Post } from "../models/Board/Post";
export const getBoardsWithImages = (year: string): Promise<any> => {
    return new Promise(async (resolve, reject) => {
        try {
            const boards = await Board.aggregate([
                // Find by year
                { $match: { year } },
                // Unwind the Posts array
              
                { $group: {
                    _id: '$year',
                    boards: {

                   
                     $push: '$$ROOT' }
                }},
                //display the id of board
               
                             // poppulate posts
                { $lookup: {
                    from: 'posts',
                    localField: 'boards.Posts',
                    foreignField: '_id',
                    as: 'boards.Posts'
                }},
                {
                    $unwind: '$boards.Posts'
                },
                {
                    $project: {
                        "boards.Posts.createdAt": 0,
                        "boards.Posts.updatedAt": 0,
                        "boards.Posts.__v": 0
                    }
                },
                //populate role of posts
                { $lookup: {
                    from: 'boardroles',
                    localField: 'boards.Posts.role',
                    foreignField: '_id',
                    as: 'boards.Posts.role'
                }},
                {
                    $project: {
                        "boards.Posts.role.createdAt": 0,
                        "boards.Posts.role.updatedAt": 0,
                        "boards.Posts.role.__v": 0
                    }
                },
                {
                    $unwind: '$boards.Posts.role'
                },
                {
                    $lookup: {
                        from: 'members',
                        localField: 'boards.Posts.Assignto',
                        foreignField: '_id',
                        as: 'boards.Posts.AssigntoDetails'
                    }
                },
                {
                    $lookup: {
                        from: 'files', // Assuming 'files' is the name of your File collection
                        localField: 'boards.Posts.AssigntoDetails.Images', // The field in the Member collection
                        foreignField: '_id', // The field in the File collection to match against
                        as: 'AssigntoImages' // New field to store the image details
                    }
                },
                {
                    $project: {
                        'boards.Posts.Assignto':[
                                {
                                    id: { $arrayElemAt: ['$boards.Posts.AssigntoDetails._id', 0] },
                                    firstName: { $arrayElemAt: ['$boards.Posts.AssigntoDetails.firstName', 0] },
                                    Images: {
                                        $map: {
                                            input: '$AssigntoImages',
                                            as: 'image',
                                            in: {
                                                _id: '$$image._id',
                                                url:"$$image.url"
                                            }
                                        }
                                    }


                        }],
                        'boards.Posts._id': 1,
                        'boards.Posts.role': 1
                    }
                },
                {
                    $group: {
                        _id: {
                            year: '$_id',
                            priority: '$boards.Posts.role.priority'
                        },
                        Posts: {
                            $push: {
                                _id: '$boards.Posts._id',
                                BoardRole_id: '$boards.Posts.role._id',
                                role: '$boards.Posts.role.name',
                                Assignto: '$boards.Posts.Assignto'
                            }
                        }
                    }
                },
                {
                    $sort: { '_id.year': 1, '_id.priority': 1 }
                },
                {
                    $group: {
                        _id: '$_id.year',
                        PostsByPriority: { $push: '$Posts' }
                    }
                },
                {
                    $project: {
                        _id: 1,
                        boards: {
                            Posts: '$PostsByPriority'
                        }
                    }
                },
                { $sort: { '_id': 1 } }
            ]);

            resolve(boards);

        } catch (error) {
            reject(error);
        }
    });
};
export const getAllYearsOfBoards = async () => {
    try {
      const years = await Board.aggregate([
        {
          $group: {
            _id: '$year',
            years: { $addToSet: '$year' } // Push unique years into an array
          }
        },
        {
          $unwind: '$years' // Unwind the years array
        },
        {
          $sort: { 'years': 1 } // Sort years in ascending order
        }
      ]);
  
      // Extract the unique years from the result
      const uniqueYears = years.map((yearObj: { years: string }) => yearObj.years);
  
      return uniqueYears;
    } catch (error) {
      console.error('Error fetching years of boards:', error);
      throw error; // or handle the error as per your application's needs
    }
  };
  async function storeFileWithGridFS(req:Request, fileName:any,gfs:any) {
    const writeStream = gfs.openUploadStream(fileName);

    // Using multer to handle file from request
    const fileBuffer = req.file!.buffer; // Accessing the file buffer from multer

    writeStream.write(fileBuffer);
    writeStream.end();

    return new Promise((resolve, reject) => {
        writeStream.on('finish', () => {
            resolve(writeStream.id);
        });

        writeStream.on('error', (error:any) => {
            reject(error);
        });
    });
}
export const createPosts=async( year: string) =>{
    let post=[];
    const roles=await BoardRole.find();
    if (roles.length>0){
    for (let role=0; role<roles.length;role++){
const newPost=await new Post({role:roles[ role]._id,year:year});
await newPost.save();
if (newPost){
    post.push(newPost.id)
}
    }
    
    }
    return post;
}