import asyncHandler from "express-async-handler";
import Notes from "../models/notesModel.js";

//@desc Get all notes
//@route Get /api/notes/getAllnotes
//@acess private
const getNotes = asyncHandler(async (req, res) => {
  const notes = await Notes.find({ isRecycled: false, userId: req.user.id });
  res.status(200).json(notes);
// console.log(notes);
});

//@desc Get all notes
//@route Get /api/notes/getAllnotes
//@acess private
const getNote = asyncHandler(async (req, res) => {
  const note = await Notes.findById(req.params.id);
  if (!note) {
      res.status(404);
      throw new Error("Contact not found");
  }
  console.log("api hitting");
  res.status(200).json(note);
});

//@desc Create new note
//@route Post /api/notes
//@acess private
const createNote = asyncHandler(async (req, res) => {
  console.log("The request body is:", req.body);
  const userId = req.user.id;
  const { title, description } = req.body;

  if (!title || !description) {
    res.status(400);
    throw new Error("All fields are mandatory");
  }
  const note = await Notes.create({
    title,
    description,
    userId: userId,
  });
  res.status(201).json(note);
});

//@desc Delete note
//@route DELETE /api/notes/:id
//@acess private
const deleteNotes = asyncHandler(async (req, res) => {
  const { noteIds } = req.body;

  if (!noteIds || !Array.isArray(noteIds)) {
    res.status(400);
    throw new Error("Please provide an array of note IDs to delete");
  }

  for (const noteId of noteIds) {
    const note = await Notes.findById(noteId);
    if(note.userId.toString() !== req.user.id){
      res.status(403);
      throw new Error("User dont have permission");
      }
      await Notes.findByIdAndDelete(note);
  }
  console.log("Notes deleted successfully")
  res.status(200).json({
    message: "Notes deleted",
  });

});

//@desc Update note
//@route Put /api/notes/:id
//@acess private
const updateNote = asyncHandler(async (req, res) => {
  const note = await Notes.findById(req.params.id);
  console.log(note);
  if (!note) {
    res.status(404);
    throw new Error("note not found");
  }
  if (note.userId.toString() !== req.user.id) {
    res.status(403);
    throw new Error("User dont have permission");
  }

  const updatedNote = await Notes.findByIdAndUpdate(req.params.id, req.body,{ new: true });
  console.log(updatedNote);
  res.status(200).json(updatedNote);

});

//@desc Move note to recycle bin
//@route PUT /api/notes/recycle/:id
//@acess private
const moveToRecycleBin = asyncHandler(async (req, res) => {
  const note = await Notes.findById(req.params.id);

  if (!note) {
    res.status(404);
    throw new Error("Note not found");
  }
  if (note.userId.toString() !== req.user.id) {
    res.status(403);
    throw new Error("User dont have permission");
  }
  note.isRecycled = true;
  await note.save();
  res.status(200).json({
    message: "Note moved to recycle bin",
    note,
  });
});

//@desc move note to the bin
//@route PUT /api/notes/tobin
//@acess private
const moveMultipleToRecycleBin = asyncHandler(async (req, res) => {
  const { noteIds } = req.body;

  for (const noteId of noteIds) {
    const note = await Notes.findById(noteId);
    if (!note) {
      continue;
    }
    if (note.userId.toString() !== req.user.id) {
      res.status(403);
      throw new Error("User dont have permission");
    }
    note.isRecycled = true;
    await note.save();
  }
console.log("multiple to bin")
  res.status(200).json({
    message: "Notes moved to recycle bin",
  });
});

//@desc Get all notes that is in the bin
//@route GET /api/notes/tobin
//@acess private
const getrecycledNotes = asyncHandler(async (req, res) => {
  const notes = await Notes.find({ isRecycled: true, userId: req.user.id});
  res.status(200).json(notes);
  console.log(notes);
});

//@desc Set password to the note
//@route PUT /api/notes/password/:id
//@acess private
const setPassword = asyncHandler(async (req, res) => {
  const { password } = req.body;
  const note = await Notes.findById(req.params.id);

  if (!note) {
    res.status(404);
    throw new Error("Note not found");
  }
  if(note.userId.toString() !== req.user.id){
    res.status(403);
    throw new Error("User dont have permission");
    }
  note.isPassword = password;
  await note.save();
  console.log(password);
  console.log("password set succesfully");
  res.status(200).json({
    message: "Pasword is Set",
  });
});

//@desc Remove password from the note
//@route PUT /api/notes/removepassword/:id
//@acess private
const removePassword = asyncHandler(async (req, res) => {
  const {password } = req.body; // Assuming password is sent in the request body

  const note = await Notes.findById(req.params.id);

  if (!note) {
    res.status(404);
    throw new Error("Note not found");
  }

  if (note.userId.toString() !== req.user.id) {
    res.status(403);
    throw new Error("User doesn't have permission");
  }

  if (note.isPassword !== password) {
    res.status(401);
    throw new Error("Incorrect password");
  }

  note.isPassword = null;
  await note.save();

  console.log("Password removed successfully");

  res.status(200).json({
    message: "Password is removed",
  });
});


const restoreNotes = asyncHandler(async (req, res) => {
  const { noteIds } = req.body;

  for (const noteId of noteIds) {
    const note = await Notes.findById(noteId);
    if (!note) {
      continue;
    }
    if (note.userId.toString() !== req.user.id) {
      res.status(403);
      throw new Error("User dont have permission");
    }
    note.isRecycled = false;
    await note.save();
  }
console.log("multiple to  notes page")
  res.status(200).json({
    message: "Notes restored from recycle bin",
  });
});

export {
  getNotes,
  createNote,
  deleteNotes,
  updateNote,
  moveToRecycleBin,
  moveMultipleToRecycleBin,
  getrecycledNotes,
  setPassword,
  removePassword,
  restoreNotes,
  getNote,
};
