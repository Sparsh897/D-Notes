import express from "express";
import { currentUser, getAllUsers, loginUser, registerUser,  } from "../controllers/userController.js";
import validateToken from "../middleware/tokenHandler.js";
import sendEmail from "../forgotPassword.js";

const UserRouter = express.Router();

UserRouter.post("/register", registerUser);

UserRouter.post("/login", loginUser);

UserRouter.get("/current",validateToken,currentUser);

UserRouter.get("/getAllusers",getAllUsers)

UserRouter.post("/sendemail",sendEmail);
// UserRouter.post("/forgotpassword",resetpassword)
export default UserRouter;
