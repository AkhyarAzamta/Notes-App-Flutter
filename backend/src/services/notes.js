import { prisma } from "../application/database.js";
import { HttpException } from "../middleware/error.js";
export const createNote = async (userId, request) => {
const note = await prisma.notes.create({
data: {
name: request.name,
description: request.description,
usersId: userId,
},
});
return note;
};

export const getNotes = async (userId, page = 1, limit = 5) => {
  const notes = await prisma.notes.findMany({
  where: {
  usersId: userId,
  },
  skip: (page - 1) * limit,
  take: limit,
  });
  if (notes.length === 0) {
  throw new HttpException(404, "No notes found");
  }
  const totalNotes = await prisma.notes.count({
  where: {
  usersId: userId,
  },
  });
  const totalPages = Math.ceil(totalNotes / limit);
  return {
  message: "Notes retrieved successfully",
  data: notes,
  paging: {
  page,
  page_size: limit,
  total_item: totalNotes,
  total_page: totalPages,
  },
  };
  };

  export const getNote = async (userId, noteId) => {
const note = await prisma.notes.findFirst({
where: {
id: noteId,
usersId: userId,
},
});
if (!note) {
throw new HttpException(404, "Note not found");
}
return note;
};

export const updateNote = async (userId, noteId, request) => {
  const note = await prisma.notes.update({
  where: {
  id: noteId,
  usersId: userId,
  },
  data: {
  name: request.name,
  description: request.description,
  },
  });
  if (!note) {
  throw new HttpException(404, "Note not found");
  }
  return note;
  };

  export const deleteNote = async (userId, noteId) => {
    const findNote = await prisma.notes.findFirst({
    where: {
    id: noteId,
    usersId: userId,
    },
    });
    if (!findNote) {
    throw new HttpException(404, "Note not found");
    }
    await prisma.notes.delete({
    where: {
    id: noteId,
    usersId: userId,
    },
    });
    return {
    message: "Note deleted successfully",
    };
    };