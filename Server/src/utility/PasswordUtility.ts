import bcrypt from 'bcrypt';



export const GenerateSalt = async () => {
  const salt = await bcrypt.genSalt();
  return salt;
};

export const HashPassword = async (password: string, salt: string) => {
  const hash = await bcrypt.hash(password, salt);
  return hash;
};

export const ValidatePassword = async (
  enteredPassword: string,
  savedPassword: string,
  salt: string
) => {
  return await HashPassword(enteredPassword, salt) === savedPassword;
};

