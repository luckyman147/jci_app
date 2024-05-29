import ExcelJS from 'exceljs';
import { Response } from 'express';
import fs from 'fs';
import { GridFSBucket, GridFSBucketWriteStream, MongoClient } from 'mongodb';
import path from 'path';

interface Member {
    firstName: string;
    phone: string;
    email: string;
}

require('dotenv').config({ path: 'Server\\src\\.env' });

export const createAndUploadExcel = async (members: Member[][], res: Response, activityName: string): Promise<void> => {
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Members');

    // Add header row
    worksheet.columns = [
        { header: 'First Name', key: 'firstName', width: 20 },
        { header: 'Phone', key: 'phone', width: 15 },
        { header: 'Email', key: 'email', width: 25 },
    ];
console.log(members)

    // Add data rows
    members.forEach((members) => {
        members.forEach((member) => {
          worksheet.addRow(member);
        });
      });
      

    // Create a buffer to write the Excel file
    const buffer = await workbook.xlsx.writeBuffer();

    // Connect to MongoDB
    const MongoURI = process.env.MONGO_URL;
    const dbName = 'jci'; // Replace with your database name
    const client = new MongoClient(MongoURI!, );

    try {
        await client.connect();
        const db = client.db(dbName);

        // Create a GridFSBucket instance
        const bucket = new GridFSBucket(db, { bucketName: 'participants' });

        let filename = `${activityName}.xlsx`;
        let uploadStream: GridFSBucketWriteStream;

        // Check if the file already exists
        const fileExists = await db.collection('participants.files').findOne({ filename });

        if (fileExists) {
            // File with the same name already exists, find a new name with an incremented index
            let index = 1;
            let newFilename = `${activityName}_${index}.xlsx`;
            while (await db.collection('participants.files').findOne({ filename: newFilename })) {
                // Increment index until a unique filename is found
                index++;
                newFilename = `${activityName}_${index}.xlsx`;
            }
            filename = newFilename;
        }

        // Upload the Excel file to GridFS with the new filename
        uploadStream = bucket.openUploadStream(filename);

        // Handle errors during the upload process
        uploadStream.on('error', (error) => {
            console.error('Error uploading file:', error);
            res.status(500).json({ error: 'Failed to upload file to MongoDB GridFS bucket' });
        });

        // End the stream and write the buffer
        uploadStream.end(buffer);

        // Wait for the upload to finish
        await new Promise<void>((resolve, reject) => {
            uploadStream.on('finish', async () => {
                console.log('File uploaded successfully.');

                // Set response headers
                res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
                res.setHeader('Content-Disposition', `attachment; filename=${filename}`);

                // Send the file back as a download
                res.status(200).send(buffer);

                resolve();
            });
        });
    } catch (error) {
        console.error('Error connecting to MongoDB:', error);
        res.status(500).json(error);
    } finally {
        await client.close();
    }
};
