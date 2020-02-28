import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { Group } from "./Group";
import { MangopayLegalUser } from "./MangopayLegalUser";

@Index("MangopayLegalUserGroup_groupId", ["groupId"], {})
@Entity("MangopayLegalUserGroup", { schema: "db" })
export class MangopayLegalUserGroup {
  @Column("int", { name: "walletId", nullable: true })
  walletId: number | null;

  @Column("int", { primary: true, name: "legalUserId" })
  legalUserId: number;

  @Column("int", { primary: true, name: "groupId" })
  groupId: number;

  @ManyToOne(
    () => Group,
    group => group.mangopayLegalUserGroups,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "groupId", referencedColumnName: "id" }])
  group: Group;

  @ManyToOne(
    () => MangopayLegalUser,
    mangopayLegalUser => mangopayLegalUser.mangopayLegalUserGroups,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "legalUserId", referencedColumnName: "mangopayUserId" }])
  legalUser: MangopayLegalUser;
}
