import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { CagettePro } from "./CagettePro";
import { User } from "./User";

@Index("PUserCompany_companyId", ["companyId"], {})
@Entity("PUserCompany", { schema: "db" })
export class PUserCompany {
  @Column("int", { primary: true, name: "companyId" })
  companyId: number;

  @Column("int", { primary: true, name: "userId" })
  userId: number;

  @Column("tinyint", { name: "legalRepresentative", width: 1 })
  legalRepresentative: boolean;

  @ManyToOne(
    () => CagettePro,
    cagettePro => cagettePro.pUserCompanies,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "companyId", referencedColumnName: "id" }])
  company: CagettePro;

  @ManyToOne(
    () => User,
    user => user.pUserCompanies,
    { onDelete: "CASCADE", onUpdate: "RESTRICT" }
  )
  @JoinColumn([{ name: "userId", referencedColumnName: "id" }])
  user: User;
}
