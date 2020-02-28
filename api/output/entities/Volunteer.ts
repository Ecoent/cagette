import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { MultiDistrib } from "./MultiDistrib";
import { User } from "./User";
import { VolunteerRole } from "./VolunteerRole";

@Index("Volunteer_volunteerRoleId", ["volunteerRoleId"], {})
@Index("Volunteer_multiDistribId", ["multiDistribId"], {})
@Entity("Volunteer", { schema: "db" })
export class Volunteer {
  @Column("int", { primary: true, name: "userId" })
  userId: number;

  @Column("int", { primary: true, name: "multiDistribId" })
  multiDistribId: number;

  @Column("int", { primary: true, name: "volunteerRoleId" })
  volunteerRoleId: number;

  @ManyToOne(
    () => MultiDistrib,
    multiDistrib => multiDistrib.volunteers,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "multiDistribId", referencedColumnName: "id" }])
  multiDistrib: MultiDistrib;

  @ManyToOne(
    () => User,
    user => user.volunteers,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;

  @ManyToOne(
    () => VolunteerRole,
    volunteerRole => volunteerRole.volunteers,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "volunteerRoleId", referencedColumnName: "id" }])
  volunteerRole: VolunteerRole;
}
