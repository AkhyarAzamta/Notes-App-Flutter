import { prisma } from "../application/database.js";
import { HttpException } from "../middleware/error.js";

// Fungsi untuk membuat catatan baru
export const createNote = async (userId, request) => {
  try {
    const note = await prisma.notes.create({
      data: {
        name: request.name,
        description: request.description,
        usersId: userId,
      },
    });
    return note;
  } catch (error) {
    throw new HttpException(500, "Failed to create note");
  }
};

// Fungsi untuk mendapatkan catatan
export const getNotes = async (userId, page = 1, limit = 5) => {
  // Pastikan page dan limit adalah angka
  const parsedPage = parseInt(page, 10) || 1;
  const parsedLimit = parseInt(limit, 10) || 5;

  // Logging untuk debugging
  console.log(`Fetching notes for userId: ${userId}, page: ${parsedPage}, limit: ${parsedLimit}`);

  try {
    const notes = await prisma.notes.findMany({
      where: {
        usersId: userId,
      },
      skip: (parsedPage - 1) * parsedLimit,
      take: parsedLimit,
    });

    // Logging hasil kueri
    console.log(`Found notes: ${JSON.stringify(notes)}`);

    // Jika tidak ada catatan, kembalikan data kosong
    const totalNotes = await prisma.notes.count({
      where: {
        usersId: userId,
      },
    });

    const totalPages = Math.ceil(totalNotes / parsedLimit);

    return {
      message: notes.length > 0 ? "Notes retrieved successfully" : "No notes found",
      data: notes,
      paging: {
        page: parsedPage,
        page_size: parsedLimit,
        total_item: totalNotes,
        total_page: totalPages,
      },
    };
  } catch (error) {
    throw new HttpException(500, "Failed to retrieve notes");
  }
};

// Fungsi untuk mendapatkan catatan berdasarkan ID
export const getNote = async (userId, noteId) => {
  try {
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
  } catch (error) {
    throw new HttpException(500, "Failed to retrieve note");
  }
};

// Fungsi untuk memperbarui catatan
export const updateNote = async (userId, noteId, request) => {
  try {
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
  } catch (error) {
    throw new HttpException(500, "Failed to update note");
  }
};

// Fungsi untuk menghapus catatan
export const deleteNote = async (userId, noteId) => {
  try {
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
  } catch (error) {
    throw new HttpException(500, "Failed to delete note");
  }
};
