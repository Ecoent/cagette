import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn
} from "typeorm";
import { User } from "./User";
import { MangopayLegalUserGroup } from "./MangopayLegalUserGroup";

@Index("MangopayLegalUser_legalReprId", ["legalReprId"], {})
@Entity("MangopayLegalUser", { schema: "db" })
export class MangopayLegalUser {
  @PrimaryGeneratedColumn({ type: "int", name: "mangopayUserId" })
  mangopayUserId: number;

  @Column("varchar", { name: "name", length: 256 })
  name: string;

  @Column("varchar", { name: "companyNumber", nullable: true, length: 256 })
  companyNumber: string | null;

  @Column("varchar", { name: "legalStatus", nullable: true, length: 32 })
  legalStatus: string | null;

  @Column("double", { name: "fixedFeeAmount", precision: 22 })
  fixedFeeAmount: number;

  @Column("double", { name: "variableFeeRate", precision: 22 })
  variableFeeRate: number;

  @Column("tinyint", { name: "disabled", width: 1 })
  disabled: boolean;

  @Column("int", { name: "legalReprId" })
  legalReprId: number;

  @Column("int", { name: "bankAccountId", nullable: true })
  bankAccountId: number | null;

  @ManyToOne(
    () => User,
    user => user.mangopayLegalUsers,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "legalReprId", referencedColumnName: "id" }])
  legalRepr: User;

  @OneToMany(
    () => MangopayLegalUserGroup,
    mangopayLegalUserGroup => mangopayLegalUserGroup.legalUser
  )
  mangopayLegalUserGroups: MangopayLegalUserGroup[];
}
