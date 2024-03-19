import { Request, Response, NextFunction } from 'express';

// Define a custom interface to extend the Response type
export interface PaginatedResponse extends Response {
    paginatedResults?: any; // Define the paginatedResults property
}

function paginatedResults(model: any) {
    return async (req: Request, res: Response, next: NextFunction) => {
        try {
            const page: number = parseInt(req.query.page as string);
            const limit: number = parseInt(req.query.limit as string);

            const startIndex: number = (page - 1) * limit;
            const endIndex: number = page * limit;

            const results: any = {};

            if (endIndex < await model.countDocuments().exec()) {
                results.next = {
                    page: page + 1,
                    limit: limit
                };
            }

            if (startIndex > 0) {
                results.previous = {
                    page: page - 1,
                    limit: limit
                };
            }

        } catch (error) {
            res.status(500).json({ message: error });
        }
    };
}

export default paginatedResults;
