import bcrypt from "bcryptjs";

export async function verifyCredentials(username: string, password: string): Promise<boolean> {
  const validUsername = process.env.DEVOPS_USERNAME || "admin";
  const validPasswordHash = process.env.DEVOPS_PASSWORD_HASH;

  // Check username
  if (username !== validUsername) {
    return false;
  }

  // If hash is provided, use it
  if (validPasswordHash) {
    return bcrypt.compare(password, validPasswordHash);
  }

  // Fallback to plain text password (for development only)
  const validPassword = process.env.DEVOPS_PASSWORD || "changeme";
  return password === validPassword;
}

export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, 10);
}
