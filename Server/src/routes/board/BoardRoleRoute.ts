import express from "express";
import { AddBoardRole, DeleteBoardRole, GetAllBoardRoles, UpdateBoardRole } from "../../controllers/Board/boardRoleController";




const router =express.Router()

/**
 * @swagger
 * /BoardRole/{priority}:
 *   get:
 *     summary: Get all board roles
 *     parameters:
 *       - in: path
 *         name: priority
 *         required: true
 *         schema:
 *           type: string
 *         description: priority of the board
 *     responses:
 *       200:
 *         description: Successfully retrieved the board roles
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   _id:
 *                     type: string
 *                     description: The ID of the board role
 *                   name:
 *                     type: string
 *                     description: The name of the board role
 *                   priority:
 *                     type: number
 *                     description: The priority of the board role
 */

router.get('/:priority',GetAllBoardRoles)
/**
 * @swagger
 * /BoardRole/AddBoardRole:
 *   post:
 *     summary: Add a board Role
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               priority:
 *                 type:number
 *             required:
 *               - name
 *               - priority
 *     responses:
 *       201:
 *         description: Successfully added a board Role 
 */

router.post('/AddBoardRole',AddBoardRole)

/**
 * @swagger
 * /BoardRole/{id}:
 *   patch:
 *     summary: Update a board Role
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: id of the board role
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               priority:
 *                 type:number
 *             required:
 *               - name
 *               - priority
 *     responses:
 *       200:
 *         description: Successfully patch a board Role 
 */

router.patch('/:id',UpdateBoardRole)
/**
 * @swagger
 * /BoardRole/{id}:
 *   delete:
 *     summary: Delete a board role by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the board role
 *     responses:
 *       204:
 *         description: Successfully deleted the board role
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Board role deleted successfully
 */


router.delete("/:id",DeleteBoardRole)

export { router as BoardRoleRouter };
