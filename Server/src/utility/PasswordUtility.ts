import bcrypt from 'bcrypt';



export const GenerateSalt = async () => {
  const salt = await bcrypt.genSalt();
  return salt;
};

export const HashPassword = async (password: string, salt: string) => {
  const hash = await bcrypt.hash(password, salt);
  return hash;
};
export const  generateStrongPassword=(length: number): string =>{
  const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lowercase = 'abcdefghijklmnopqrstuvwxyz';
  const numbers = '0123456789';
  const specialCharacters = '!@#$%^&*()-_=+[]{}|;:,.<>?';

  const allCharacters = uppercase + lowercase + numbers + specialCharacters;
  const getRandomCharacter = (characters: string): string => {
    return characters[Math.floor(Math.random() * characters.length)];
  };

  let password = '';

  // Ensure the password contains at least one of each type of character
  password += getRandomCharacter(uppercase);
  password += getRandomCharacter(lowercase);
  password += getRandomCharacter(numbers);
  password += getRandomCharacter(specialCharacters);

  // Fill the rest of the password length with random characters from allCharacters
  while (password.length < length) {
    password += getRandomCharacter(allCharacters);
  }

  // Shuffle the password to avoid predictable patterns
  const shuffleArray = (array: string[]): string[] => {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
  };

  return shuffleArray(password.split('')).join('');
};


export const ValidatePassword = async (
  enteredPassword: string,
  savedPassword: string,
  salt: string
) => {
  return await HashPassword(enteredPassword, salt) === savedPassword;
};

