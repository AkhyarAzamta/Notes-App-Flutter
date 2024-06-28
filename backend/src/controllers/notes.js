import {
  createNote,
  deleteNote,
  getNote,
  getNotes,
  updateNote,
  } from "../services/notes.js";
export const notesController = {
create: async (req, res, next) => {
try {
const result = await createNote(req.user.id, req.body);
return res.status(201).json(result);
} catch (error) {
next(error);
}
},

get: async (req, res, next) => {
  try {
  const page = req.query.page || 1;
  const limit = req.query.page_size || 5;
  const result = await getNotes(req.user.id, page, limit);
  return res.status(200).json(result);
  } catch (error) {
  next(error);
  }
  },

  getOne: async (req, res, next) => {
    try {
    const result = await getNote(req.user.id, req.params.id);
    return res.status(200).json(result);
    } catch (error) {
    next(error);
    }
    },

    update: async (req, res, next) => {
      try {
      const result = await updateNote(req.user.id, req.params.id, req.body);
      return res.status(200).json(result);
      } catch (error) {
      next(error);
      }
      },

      delete: async (req, res, next) => {
        try {
        const result = await deleteNote(req.user.id, req.params.id);
        return res.status(200).json(result);
        } catch (error) {
        next(error);
        }
        },
        };