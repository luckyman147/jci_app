import express from "express";
import { addBoard, deleteBoard, getBoardByYear, getyears } from "../../controllers/Board/BoardController";
import { AuthenticateSuperAdmin } from "../../middleware/CommonAuth";




const router =express.Router()
/**
 * @swagger
 * /Board/AddBoard:
 *   post:
 *     security:
 *       - bearerAuth: []
 *     summary: Add a board
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               year:
 *                 type: string
 *             required:
 *               - year
 *     responses:
 *       200:
 *         description: Successfully added a board
 */

router.post('/AddBoard',AuthenticateSuperAdmin,addBoard)
/**
 * @swagger
 * /Board/get/{year}:
 *   get:
 *     summary: Get a board by year
 *     parameters:
 *       - in: path
 *         name: year
 *         required: true
 *         schema:
 *           type: string
 *         description: Year of the board
 *     responses:
 *       200:
 *         description: Successfully retrieved the board
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 year:
 *                   type: string

 */

router.get('/get/:year',getBoardByYear)
/**
 * @swagger
 * /Board/years:
 *   get:
 *     summary: Get  years
 *     
 *     responses:
 *       200:
 *         description: Successfully retrieved the years
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 year:
 *                   type: string

 */
router .get('/years',getyears)

/**
 * @swagger
 * /Board/{id}:
 *   delete:
 *     summary: Get a board by year
 *     parameters:
 *       - in: path
 *         name: year
 *         required: true
 *         schema:
 *           type: string
 *         description: year of the board
 *     responses:
 *       204:
 *         description: Successfully deleted  the board
 *         content:
 *           application/json:
 *         schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Board  deleted successfully

 */

router.delete("/:id",deleteBoard)

export { router as BoardRouter };
