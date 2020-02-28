import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { Group } from "./Group";
import { User } from "./User";

@Index("Membership_amapId", ["amapId"], {})
@Entity("Membership", { schema: "db" })
export class Membership {
  @Column("int", { primary: true, name: "amapId" })
  amapId: number;

  @Column("int", { primary: true, name: "userId" })
  userId: number;

  @Column("int", { primary: true, name: "year" })
  year: number;

  @Column("date", { name: "date", nullable: true })
  date: string | null;

  @ManyToOne(
    () => Group,
    group => group.memberships,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "amapId", referencedColumnName: "id" }])
  amap: Group;

  @ManyToOne(
    () => User,
    user => user.memberships,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
