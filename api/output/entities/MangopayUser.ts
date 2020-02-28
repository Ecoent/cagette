import {
  Column,
  Entity,
  JoinColumn,
  OneToOne,
  PrimaryGeneratedColumn
} from "typeorm";
import { User } from "./User";

@Entity("MangopayUser", { schema: "db" })
export class MangopayUser {
  @Column("int", { name: "mangopayUserId" })
  mangopayUserId: number;

  @PrimaryGeneratedColumn({ type: "int", name: "userId" })
  userId: number;

  @OneToOne(
    () => User,
    user => user.mangopayUser,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
