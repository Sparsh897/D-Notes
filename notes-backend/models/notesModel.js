import mongoose, { Schema } from "mongoose";

export const notesSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "User",
    },
    title: {
      type: String,
      required: [true, "Please add the title"],
    },
    description: {
      type: String,
      required: [true, "Please add the description "],
    },
    isRecycled: {
      type: Boolean,
      default: false,
    },
    isPassword: {
      type: String,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

const Notes = mongoose.model("Notes", notesSchema);
export default Notes;
