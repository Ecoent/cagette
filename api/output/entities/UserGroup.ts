import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { Group } from "./Group";
import { User } from "./User";

@Index("UserAmap_amapId", ["groupId"], {})
@Entity("UserGroup", { schema: "db" })
export class UserGroup {
  @Column("int", { primary: true, name: "groupId" })
  groupId: number;

  @Column("int", { primary: true, name: "userId" })
  userId: number;

  @Column("mediumblob", { name: "rights", nullable: true })
  rights: Buffer | null;

  @Column("double", { name: "balance", precision: 22 })
  balance: number;

  @ManyToOne(
    () => Group,
    group => group.userGroups,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => User,
    user => user.userGroups,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
