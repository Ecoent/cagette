import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { Group } from "./Group";
import { User } from "./User";

@Index("WaitingList_amapId", ["amapId"], {})
@Entity("WaitingList", { schema: "db" })
export class WaitingList {
  @Column("int", { primary: true, name: "amapId" })
  amapId: number;

  @Column("int", { primary: true, name: "userId" })
  userId: number;

  @Column("datetime", { name: "date" })
  date: Date;

  @Column("mediumtext", { name: "message" })
  message: string;

  @ManyToOne(
    () => Group,
    group => group.waitingLists,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "amapId", referencedColumnName: "id" }])
  amap: Group;

  @ManyToOne(
    () => User,
    user => user.waitingLists,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
