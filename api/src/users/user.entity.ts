import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";



@Entity('User')
export class User{

    @PrimaryGeneratedColumn()
    id:number;

    @Column()
    firstName:string;

    @Column()
    lastName:string;

    @Column()
    lang:string;

   
    public toString(){
        return "#"+this.id+" "+this.firstName+" "+this.lastName;
    }

    public infos(){
        return {
            id : this.id,
            lastName : this.lastName,
            firstName : this.firstName
        };
    }
}