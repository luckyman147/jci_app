import { Role } from "../models/role";

export const findrole=async (name:string)=>{
    const role = await Role.findOne({ name: name });
    if (role){
        return role
    }
}

export const findroleByid=async (id:string)=>{
const role = await Role.findById(id);
if (role){
    return role.name;
}
}