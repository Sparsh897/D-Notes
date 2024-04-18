import express from "express";
import AdminJS from 'adminjs';
import mongoose from "mongoose";
import AdminJSExpress from '@adminjs/express';
import errorHandler from './middleware/errorHandler.js';
import dotenv from "dotenv";
import notesRoutes from "./routes/notesRoutes.js";
import userRoutes from "./routes/userRoutes.js"
import {Database , Resource} from "@adminjs/mongoose";
import path from "path"; 
// import sendEmail from "./config/forgotPassword.js";


AdminJS.registerAdapter({
  Database,
  Resource
})
dotenv.config(); 

const databaseConnect = await mongoose.connect(process.env.MONGO_DGB_URI);
const app = express();
app.use(express.json());
app.use("/api/note", notesRoutes);
app.use("/api/users", userRoutes);
app.use(errorHandler);
// sendEmail();
app.get('/reset-password.html', (req, res) => {
  const filePath = new URL('./config/reset-password.html', import.meta.url).pathname;
  res.sendFile(path.resolve(filePath));
});



const port = process.env.PORT || 5000;

const start = async () => {
  const admin = new AdminJS({
  databases:[
  databaseConnect
   ],
  //  resources:[{}]
  });
  const adminRouter = AdminJSExpress.buildRouter(admin);

  app.use(admin.options.rootPath, adminRouter);

  app.listen(port, () => {
    console.log(`AdminJS started on http://localhost:${port}${admin.options.rootPath}`);
  });
 
};

start();
