import asyncHandler from "express-async-handler";
import User from "../models/User.js";
import bcrypt from "bcrypt";
import Jwt from "jsonwebtoken";
import bodyParser from 'body-parser';
// import {sendResetEmail,generateResetToken} from '../config/forgotPassword.js'; 






// const resetpassword =asyncHandler(async  (req, res) => {
//   const { email } = req.body;

//   sendResetEmail(email)
//     .then(() => {
//       res.send('Password reset email sent');
//     })
//     .catch(error => {
//       console.error('Error sending password reset email:', error);
//       res.status(500).send('Error sending password reset email');
//     });
// });



// import UserService from "../services/user_services.js";

// exports.registerUser =async()=>{
//     try{
//         const { username, email, password } = req.body;
//     }catch(error){
// throw error;
//     }
// }

// @desc Register a User
// @route Post /api/users/register
// @access public
const registerUser = asyncHandler(async (req, res) => {
  console.log("The request body is:", {
    email: req.body.email,
  });
  const { email, password } = req.body;

  if (!email || !password) {
    res.status(400);
    throw new Error("All fields are mandotry");
  }

  const userAvailable = await User.findOne({ email });
  if (userAvailable) {
    res.status(400);
    throw new Error("User is already registered");
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      email,
      password: hashedPassword,
    });

    await user.save();

    if (user) {
      res.status(201).json({ _id: user.id, email: user.email });
    } else {
      res.status(400);
      throw new Error("user data is not valid");
    }
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
});

// @desc Login a User
// @route Post /api/users/login
// @access public
const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    res.status(400);
    throw new Error("All fields are mandatory");
  }
  const user = await User.findOne({ email });
  if (user && (await bcrypt.compare(password, user.password))) {
    const accessToken = Jwt.sign(
      {
        user: {
          email: user.email,
          id: user.id,
        },
      },
      process.env.ACCESS_TOKEN_SECRET,
     
    );
    res.status(200).json({ accessToken });
    console.log(user);
    console.log(accessToken);
  } else {
    res.status(401);
    throw new Error("email or password is not valid");
  }
});

// @desc Current User info
// @route Post /api/users/current
// @access private
const currentUser = asyncHandler(async (req, res) => {
  res.json(req.user);
});

const getAllUsers = asyncHandler(async (req, res) => {
  const users = await User.find();
  res.status(200).json(users);
});




export { registerUser, loginUser, currentUser, getAllUsers, };
